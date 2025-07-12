module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    genvar i, j;
    
    generate
        for (i = 0; i < 16; i = i + 1) begin : row
            for (j = 0; j < 16; j = j + 1) begin : col
                // Calculate neighbor indices with wrap-around
                wire [3:0] x_prev = (i == 0) ? 15 : (i - 1);
                wire [3:0] x_next = (i == 15) ? 0 : (i + 1);
                wire [3:0] y_prev = (j == 0) ? 15 : (j - 1);
                wire [3:0] y_next = (j == 15) ? 0 : (j + 1);
                
                // Get neighbor values
                wire nw = q[x_prev*16 + y_prev];
                wire n  = q[x_prev*16 + j];
                wire ne = q[x_prev*16 + y_next];
                wire w  = q[i*16 + y_prev];
                wire e  = q[i*16 + y_next];
                wire sw = q[x_next*16 + y_prev];
                wire s  = q[x_next*16 + j];
                wire se = q[x_next*16 + y_next];
                
                // Count live neighbors
                wire [3:0] neighbor_count = nw + n + ne + w + e + sw + s + se;
                wire current_cell = q[i*16 + j];
                
                // Apply game rules
                assign next_q[i*16 + j] = 
                    (neighbor_count <= 1) ? 0 :
                    (neighbor_count == 2) ? current_cell :
                    (neighbor_count == 3) ? 1 :
                    0;
            end
        end
    endgenerate
    
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule