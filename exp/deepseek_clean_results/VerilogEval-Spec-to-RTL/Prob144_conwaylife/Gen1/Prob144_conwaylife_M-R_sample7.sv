module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Next state calculation
    wire [255:0] next_q;
    
    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_loop
            for (col = 0; col < 16; col = col + 1) begin : col_loop
                // Calculate neighbor count with wrap-around
                wire [3:0] neighbor_count;
                assign neighbor_count = 
                    q[((row+15)%16)*16 + ((col+15)%16)] + // top-left
                    q[((row+15)%16)*16 + col] +            // top
                    q[((row+15)%16)*16 + ((col+1)%16)] +   // top-right
                    q[row*16 + ((col+15)%16)] +            // left
                    q[row*16 + ((col+1)%16)] +             // right
                    q[((row+1)%16)*16 + ((col+15)%16)] +   // bottom-left
                    q[((row+1)%16)*16 + col] +            // bottom
                    q[((row+1)%16)*16 + ((col+1)%16)];     // bottom-right
                
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