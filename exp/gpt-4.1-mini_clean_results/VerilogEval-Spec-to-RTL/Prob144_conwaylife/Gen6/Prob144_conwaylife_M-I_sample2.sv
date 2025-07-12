module TopModule (
    input             clk,
    input             load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    reg [3:0] neighbor_counts [0:HEIGHT*WIDTH-1]; // Store 8-bit counts per cell (4 bits suffice)
    reg [255:0] intermediate_state; // Holds the input state for the next update stage

    integer r, c, dr, dc;
    integer nr, nc;
    integer idx, nidx;

    // Wrap index modulo 16 by masking lower 4 bits
    function [3:0] wrap16(input integer idx);
        begin
            wrap16 = idx & 4'hF;
        end
    endfunction

    // Combinational neighbor count calculation
    always @(*) begin
        // For each cell in the grid
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                idx = (r << 4) + c;
                neighbor_counts[idx] = 0;
                // Sum 8 neighbors
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = wrap16(r + dr);
                            nc = wrap16(c + dc);
                            nidx = (nr << 4) + nc;
                            neighbor_counts[idx] = neighbor_counts[idx] + q[nidx];
                        end
                    end
                end
            end
        end
    end

    // Sequential logic pipeline registers
    reg [3:0] neighbor_counts_reg [0:HEIGHT*WIDTH-1];
    reg [255:0] q_reg;

    // State update combinational using registered neighbor counts and stored previous state
    reg [255:0] next_q;

    always @(*) begin
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                idx = (r << 4) + c;
                // Current cell state from intermediate_state (previous q_reg)
                // Apply rules based on stored neighbor counts
                case (neighbor_counts_reg[idx])
                    2: next_q[idx] = intermediate_state[idx]; // stays same
                    3: next_q[idx] = 1'b1;                    // becomes alive
                    default: next_q[idx] = 1'b0;              // 0-1 or >=4 neighbors -> dead
                endcase
            end
        end
    end

    // Pipeline registers and load handling
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            intermediate_state <= data;
            // Reset neighbor_counts_reg to zero on load to avoid stale data
            for (idx = 0; idx < WIDTH*HEIGHT; idx = idx + 1) begin
                neighbor_counts_reg[idx] <= 4'd0;
            end
        end else begin
            // Stage 1: Register neighbor counts and store current q in intermediate_state
            for (idx = 0; idx < WIDTH*HEIGHT; idx = idx + 1) begin
                neighbor_counts_reg[idx] <= neighbor_counts[idx];
            end
            intermediate_state <= q;

            // Stage 2: Update q with next state computed from previous pipeline registers
            q <= next_q;
        end
    end

endmodule