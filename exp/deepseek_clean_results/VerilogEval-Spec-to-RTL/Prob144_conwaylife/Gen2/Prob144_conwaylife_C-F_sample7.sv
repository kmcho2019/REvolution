module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    
    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_loop
            for (col = 0; col < 16; col = col + 1) begin : col_loop
                // Calculate neighbor positions with wrap-around using bit selection
                wire [3:0] row_m1 = row - 1'b1;  // Automatically wraps due to 4-bit
                wire [3:0] row_p1 = row + 1'b1;  // Automatically wraps due to 4-bit
                wire [3:0] col_m1 = col - 1'b1;  // Automatically wraps due to 4-bit
                wire [3:0] col_p1 = col + 1'b1;  // Automatically wraps due to 4-bit
                
                // Get neighbor values
                wire nw = q[row_m1*16 + col_m1];
                wire n  = q[row_m1*16 + col];
                wire ne = q[row_m1*16 + col_p1];
                wire w  = q[row*16 + col_m1];
                wire e  = q[row*16 + col_p1];
                wire sw = q[row_p1*16 + col_m1];
                wire s  = q[row_p1*16 + col];
                wire se = q[row_p1*16 + col_p1];
                
                // Count live neighbors using 4-bit adder
                wire [3:0] neighbor_count = nw + n + ne + w + e + sw + s + se;
                
                // Apply game rules
                assign next_q[row*16 + col] = 
                    (neighbor_count == 2) ? q[row*16 + col] :
                    (neighbor_count == 3) ? 1'b1 :
                    1'b0;
            end
        end
    endgenerate

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule