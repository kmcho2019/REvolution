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
                // Calculate neighbor coordinates with wrapping
                wire [3:0] row_p = (i - 1) & 15;
                wire [3:0] row_n = (i + 1) & 15;
                wire [3:0] col_p = (j - 1) & 15;
                wire [3:0] col_n = (j + 1) & 15;
                
                // Calculate neighbor indices using shifts (instead of multiply)
                wire [7:0] n0 = {row_p, col_p};  // row_p << 4 + col_p
                wire [7:0] n1 = {row_p, j};      // row_p << 4 + j
                wire [7:0] n2 = {row_p, col_n};  // row_p << 4 + col_n
                wire [7:0] n3 = {i, col_p};      // i << 4 + col_p
                wire [7:0] n4 = {i, col_n};      // i << 4 + col_n
                wire [7:0] n5 = {row_n, col_p};  // row_n << 4 + col_p
                wire [7:0] n6 = {row_n, j};      // row_n << 4 + j
                wire [7:0] n7 = {row_n, col_n};  // row_n << 4 + col_n
                
                // Count live neighbors
                wire [3:0] count = q[n0] + q[n1] + q[n2] + q[n3] + 
                                  q[n4] + q[n5] + q[n6] + q[n7];
                
                // Apply game rules
                assign next_q[i*16 + j] = (count == 3) ? 1'b1 :
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
            q <= next_q;
        end
    end

endmodule