module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_state;
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row
            for (j = 0; j < 16; j = j + 1) begin : col
                // Calculate neighbor positions with wrap-around
                wire [3:0] row_p = (i == 0) ? 15 : (i - 1);
                wire [3:0] row_n = (i == 15) ? 0 : (i + 1);
                wire [3:0] col_p = (j == 0) ? 15 : (j - 1);
                wire [3:0] col_n = (j == 15) ? 0 : (j + 1);
                
                // Count live neighbors
                wire [3:0] count = 
                    q[row_p*16 + col_p] + q[row_p*16 + j] + q[row_p*16 + col_n] +
                    q[i*16 + col_p] + q[i*16 + col_n] +
                    q[row_n*16 + col_p] + q[row_n*16 + j] + q[row_n*16 + col_n];
                
                // Apply game rules
                assign next_state[i*16 + j] = 
                    (count == 3) ? 1'b1 : 
                    (count == 2) ? q[i*16 + j] : 
                    1'b0;
            end
        end
    endgenerate

    // Update state on clock edge
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule