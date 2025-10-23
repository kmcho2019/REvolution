module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipeline registers
    reg [255:0] q_ff;
    reg [255:0][2:0] neighbor_counts; // 3 bits sufficient (0-8)
    reg [255:0] stable_cells;

    // Shared 4-bit adder
    function [3:0] adder4;
        input [3:0] a, b;
        adder4 = a + b;
    endfunction

    // Stage 1: Calculate neighbor counts
    always @(posedge clk) begin
        if (load) begin
            q_ff <= data;
        end else begin
            q_ff <= q;
        end

        for (integer i = 0; i < 256; i = i + 1) begin
            // Calculate row and column indices
            integer row = i / 16;
            integer col = i % 16;
            
            // Calculate neighbor positions with wrap-around
            integer row_prev = (row == 0) ? 15 : (row - 1);
            integer row_next = (row == 15) ? 0 : (row + 1);
            integer col_prev = (col == 0) ? 15 : (col - 1);
            integer col_next = (col == 15) ? 0 : (col + 1);
            
            // Get neighbor values
            reg [7:0] neighbors;
            neighbors[0] = q_ff[row_prev*16 + col_prev]; // top-left
            neighbors[1] = q_ff[row_prev*16 + col];      // top
            neighbors[2] = q_ff[row_prev*16 + col_next]; // top-right
            neighbors[3] = q_ff[row*16 + col_prev];     // left
            neighbors[4] = q_ff[row*16 + col_next];      // right
            neighbors[5] = q_ff[row_next*16 + col_prev]; // bottom-left
            neighbors[6] = q_ff[row_next*16 + col];      // bottom
            neighbors[7] = q_ff[row_next*16 + col_next]; // bottom-right
            
            // Pipelined neighbor counting (stage 1)
            reg [1:0] sum_top = neighbors[0] + neighbors[1] + neighbors[2];
            reg [1:0] sum_mid = neighbors[3] + neighbors[4];
            reg [1:0] sum_bot = neighbors[5] + neighbors[6] + neighbors[7];
            
            // Stage 2: Final count using shared adder
            neighbor_counts[i] <= adder4(sum_top, sum_mid) + sum_bot;
            stable_cells[i] <= (neighbor_counts[i] == 3'd2);
        end
    end

    // Stage 2: Update state with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer i = 0; i < 256; i = i + 1) begin
                if (!stable_cells[i]) begin
                    case (neighbor_counts[i])
                        3'd3: q[i] <= 1'b1;
                        default: q[i] <= 1'b0;
                    endcase
                end
            end
        end
    end

endmodule