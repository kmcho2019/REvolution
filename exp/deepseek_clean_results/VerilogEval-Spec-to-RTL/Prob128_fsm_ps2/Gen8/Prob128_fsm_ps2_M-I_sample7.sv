module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;
    reg in3_reg;
    wire enable = (cnt != 2'b0) || in3_reg;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
            in3_reg <= 1'b0;
        end else begin
            in3_reg <= in[3];  // Register input for better timing
            
            done <= (cnt == 2'b10);  // Assert done when third byte is received
            
            if (enable) begin  // Only update counter when needed
                if (cnt == 2'b0) begin
                    cnt <= in3_reg ? 2'b01 : 2'b0;  // Start new message when in3_reg=1
                end else begin
                    cnt <= (cnt == 2'b10) ? 2'b0 : cnt + 1'b1;
                end
            end
        end
    end

endmodule