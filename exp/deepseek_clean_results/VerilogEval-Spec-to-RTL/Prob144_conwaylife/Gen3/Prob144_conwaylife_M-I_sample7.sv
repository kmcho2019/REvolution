module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipelined neighbor counts
    reg [255:0] q_ff;
    reg [3:0] neighbor_count [255:0];
    reg [255:0] next_q;

    // Clock gating signals
    wire [255:0] cell_changed;
    wire [255:0] clk_en;

    // Shift registers for row buffering
    reg [15:0] row_buf [17:0]; // Extra rows for wrap-around

    // Load data and pipeline stage
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            q_ff <= data;
        end else begin
            q_ff <= q;
            q <= next_q;
        end
    end

    // Update shift registers
    integer i;
    always @(posedge clk) begin
        // Main grid rows
        for (i = 1; i <= 16; i = i + 1)
            row_buf[i] <= q[(i-1)*16 +: 16];
        
        // Wrap-around rows
        row_buf[0] <= q[240 +: 16];  // Last row
        row_buf[17] <= q[0 +: 16];    // First row
    end

    // Neighbor counting with carry-save adders
    genvar x, y;
    generate
        for (y = 0; y < 16; y = y + 1) begin : row_gen
            for (x = 0; x < 16; x = x + 1) begin : col_gen
                // Get neighboring cells from shift registers
                wire [7:0] neighbors = {
                    row_buf[y+2][(x+15)%16],   // S, E
                    row_buf[y+2][x],            // S
                    row_buf[y+2][(x+1)%16],     // S, W
                    row_buf[y+1][(x+15)%16],    // E
                    row_buf[y+1][(x+1)%16],     // W
                    row_buf[y][(x+15)%16],      // N, E
                    row_buf[y][x],              // N
                    row_buf[y][(x+1)%16]        // N, W
                };

                // Carry-save adder for neighbor count
                wire [1:0] sum1 = neighbors[7:6] + neighbors[5:4];
                wire [1:0] sum2 = neighbors[3:2] + neighbors[1:0];
                wire [2:0] sum3 = sum1 + sum2;
                wire [3:0] sum4 = sum3 + row_buf[y+1][(x+15)%16] + row_buf[y+1][(x+1)%16];

                always @(posedge clk) begin
                    neighbor_count[y*16 + x] <= sum4;
                end

                // Activity detection and clock gating
                assign cell_changed[y*16 + x] = |neighbors || q_ff[y*16 + x];
                assign clk_en[y*16 + x] = cell_changed[y*16 + x] || load;

                // State update with optimized logic
                always @(*) begin
                    case (neighbor_count[y*16 + x])
                        2: next_q[y*16 + x] = q_ff[y*16 + x];
                        3: next_q[y*16 + x] = 1'b1;
                        default: next_q[y*16 + x] = 1'b0;
                    endcase
                end
            end
        end
    endgenerate

    // Clock gating implementation
    always @(posedge clk) begin
        for (i = 0; i < 256; i = i + 1) begin
            if (clk_en[i]) begin
                if (load)
                    q[i] <= data[i];
                else
                    q[i] <= next_q[i];
            end
        end
    end

endmodule