module TopModule (
    input           clk,
    input           load,
    input  [255:0]  data,
    output reg [255:0] q
);

    localparam WIDTH  = 16;
    localparam HEIGHT = 16;

    // Pipeline registers
    reg [3:0] neighbor_count [0:HEIGHT-1][0:WIDTH-1];  // 4 bits per cell to count neighbors 0-8
    reg [3:0] next_neighbor_count [0:HEIGHT-1][0:WIDTH-1];
    reg [255:0] next_q;

    // Pipeline stage: 0 = count neighbors, 1 = compute next state
    reg stage;

    integer r, c, dr, dc;
    integer nr, nc;
    integer count;

    // Compute neighbor counts combinationally from current q
    always @(*) begin
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                count = 0;
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = (r + dr) & 4'hF;
                            nc = (c + dc) & 4'hF;
                            count = count + q[(nr << 4) + nc];
                        end
                    end
                end
                next_neighbor_count[r][c] = count[3:0];
            end
        end
    end

    // Compute next state combinationally from neighbor_count and q
    always @(*) begin
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                case (neighbor_count[r][c])
                    0,1: next_q[(r << 4) + c] = 1'b0;
                    2:   next_q[(r << 4) + c] = q[(r << 4) + c]; // no change
                    3:   next_q[(r << 4) + c] = 1'b1;
                    default: next_q[(r << 4) + c] = 1'b0; // 4+
                endcase
            end
        end
    end

    // Sequential pipeline control
    always @(posedge clk) begin
        if (load) begin
            // Load input data, reset stage to 0
            q <= data;
            stage <= 1'b0;
            // Initialize neighbor_count to zero to avoid stale data
            for (r = 0; r < HEIGHT; r = r + 1) begin
                for (c = 0; c < WIDTH; c = c + 1) begin
                    neighbor_count[r][c] <= 4'd0;
                end
            end
        end else begin
            if (stage == 1'b0) begin
                // Stage 0: neighbor counting done combinationally; latch counts here
                for (r = 0; r < HEIGHT; r = r + 1) begin
                    for (c = 0; c < WIDTH; c = c + 1) begin
                        neighbor_count[r][c] <= next_neighbor_count[r][c];
                    end
                end
                // Stay in stage 1 next cycle to compute next state
                stage <= 1'b1;
                // q unchanged this cycle
                q <= q;
            end else begin
                // Stage 1: compute next state using neighbor_count
                q <= next_q;
                // Next cycle start neighbor counting again
                stage <= 1'b0;
            end
        end
    end

endmodule