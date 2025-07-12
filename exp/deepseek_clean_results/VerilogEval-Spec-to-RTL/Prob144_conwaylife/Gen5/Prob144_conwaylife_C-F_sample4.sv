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
                // Neighbor indices with optimized wrap-around
                wire [3:0] row_prev = (i-1) & 15;
                wire [3:0] row_next = (i+1) & 15;
                wire [3:0] col_prev = (j-1) & 15;
                wire [3:0] col_next = (j+1) & 15;
                
                // Carry-save neighbor counting
                wire [1:0] sum1 = q[row_prev*16 + col_prev] + 
                                 q[row_prev*16 + j] + 
                                 q[row_prev*16 + col_next];
                wire [1:0] sum2 = q[i*16 + col_prev] + 
                                 q[i*16 + col_next];
                wire [1:0] sum3 = q[row_next*16 + col_prev] + 
                                 q[row_next*16 + j] + 
                                 q[row_next*16 + col_next];
                wire [3:0] count = sum1 + sum2 + sum3;
                
                // Stability detection and next state
                wire stable = (count == 2) && q[i*16+j];
                wire birth = (count == 3);
                assign next_state[i*16+j] = stable ? q[i*16+j] : birth;
            end
        end
    endgenerate

    // Optimized sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer k = 0; k < 256; k = k + 1) begin
                if (next_state[k] != q[k]) begin
                    q[k] <= next_state[k];
                end
            end
        end
    end

endmodule