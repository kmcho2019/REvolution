module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    integer i, j;
    
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Calculate neighbor indices with modulo wrap-around
                integer x_prev = (i + 15) % 16;
                integer x_next = (i + 1) % 16;
                integer y_prev = (j + 15) % 16;
                integer y_next = (j + 1) % 16;
                
                // Count live neighbors (direct sum in expression)
                integer neighbor_count = 
                    q[x_prev*16 + y_prev] + q[x_prev*16 + j] + q[x_prev*16 + y_next] +
                    q[i*16 + y_prev] + q[i*16 + y_next] +
                    q[x_next*16 + y_prev] + q[x_next*16 + j] + q[x_next*16 + y_next];
                
                // Apply game rules
                next_q[i*16 + j] = 
                    (neighbor_count <= 1) ? 0 :
                    (neighbor_count == 2) ? q[i*16 + j] :
                    (neighbor_count == 3) ? 1 :
                    0;
            end
        end
    end
    
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule