module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                // Wrap-around neighbors using bitwise masking
                wire [3:0] row_p = (i-1) & 15;
                wire [3:0] row_n = (i+1) & 15;
                wire [3:0] col_p = (j-1) & 15;
                wire [3:0] col_n = (j+1) & 15;
                
                // Calculate neighbor count (sum of 8 neighbors)
                wire [3:0] count = 
                    q[{row_p, col_p}] + q[{row_p, j}] + q[{row_p, col_n}] +
                    q[{i, col_p}] + q[{i, col_n}] +
                    q[{row_n, col_p}] + q[{row_n, j}] + q[{row_n, col_n}];
                
                // Simple state transition rules
                assign next_q[i*16 + j] = (count == 3) ? 1'b1 :
                                        (count == 2) ? q[i*16 + j] :
                                        1'b0;
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load) q <= data;
        else q <= next_q;
    end

endmodule