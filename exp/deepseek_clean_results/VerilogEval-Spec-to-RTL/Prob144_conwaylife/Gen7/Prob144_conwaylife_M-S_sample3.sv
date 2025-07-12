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
                // Calculate neighbor indices with wrap-around
                wire [3:0] row_prev = (i-1) & 15;
                wire [3:0] row_next = (i+1) & 15;
                wire [3:0] col_prev = (j-1) & 15;
                wire [3:0] col_next = (j+1) & 15;
                
                // Count live neighbors
                wire [3:0] count = 
                    q[row_prev*16 + col_prev] + q[row_prev*16 + j] + q[row_prev*16 + col_next] +
                    q[i*16 + col_prev] + q[i*16 + col_next] +
                    q[row_next*16 + col_prev] + q[row_next*16 + j] + q[row_next*16 + col_next];
                
                // Determine next state
                assign next_state[i*16+j] = 
                    (count == 3) || (count == 2 && q[i*16+j]);
            end
        end
    endgenerate

    // Update state on clock edge
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule