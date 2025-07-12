module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;
    integer i, j, x, y;
    reg [3:0] count;
    
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                count = 0;
                // Check all 8 neighbors with wrap-around
                for (x = -1; x <= 1; x = x + 1) begin
                    for (y = -1; y <= 1; y = y + 1) begin
                        if (x != 0 || y != 0) begin // Skip self
                            count = count + q[((i+x+16)%16)*16 + ((j+y+16)%16)];
                        end
                    end
                end
                
                // Apply game rules
                case (count)
                    2: next_q[i*16 + j] = q[i*16 + j];
                    3: next_q[i*16 + j] = 1;
                    default: next_q[i*16 + j] = 0;
                endcase
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