module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;
    reg [255:0][3:0] neighbor_counts;

    // Stage 1: Calculate neighbor counts (registered)
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer i = 0; i < 16; i = i + 1) begin
                for (integer j = 0; j < 16; j = j + 1) begin
                    // Calculate neighbor positions with wrap-around
                    integer row_prev = (i == 0) ? 15 : (i - 1);
                    integer row_next = (i == 15) ? 0 : (i + 1);
                    integer col_prev = (j == 0) ? 15 : (j - 1);
                    integer col_next = (j == 15) ? 0 : (j + 1);

                    // Calculate neighbor indices
                    integer n0 = row_prev*16 + col_prev;
                    integer n1 = row_prev*16 + j;
                    integer n2 = row_prev*16 + col_next;
                    integer n3 = i*16 + col_prev;
                    integer n4 = i*16 + col_next;
                    integer n5 = row_next*16 + col_prev;
                    integer n6 = row_next*16 + j;
                    integer n7 = row_next*16 + col_next;

                    // Carry-save optimized neighbor counting (3-level tree)
                    reg [1:0] sum_a = q[n0] + q[n1];
                    reg [1:0] sum_b = q[n2] + q[n3];
                    reg [1:0] sum_c = q[n4] + q[n5];
                    reg [1:0] sum_d = q[n6] + q[n7];
                    
                    reg [2:0] sum_ab = sum_a + sum_b;
                    reg [2:0] sum_cd = sum_c + sum_d;
                    
                    neighbor_counts[i*16+j] <= sum_ab + sum_cd;
                end
            end
        end
    end

    // Stage 2: Calculate next state (registered)
    always @(posedge clk) begin
        if (!load) begin
            for (integer i = 0; i < 256; i = i + 1) begin
                case (neighbor_counts[i])
                    2: next_q[i] <= q[i];  // Maintain state
                    3: next_q[i] <= 1'b1;  // Birth
                    default: next_q[i] <= 1'b0;  // Death
                endcase
            end
            q <= next_q;
        end
    end

endmodule