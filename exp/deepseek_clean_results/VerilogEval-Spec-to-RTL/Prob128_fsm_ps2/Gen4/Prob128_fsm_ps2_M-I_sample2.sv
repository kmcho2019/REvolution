module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            done <= (cnt == 2'b10);  // Assert done when third byte is received
            
            if (cnt == 2'b0) begin
                if (in[3]) cnt <= 2'b01;  // Start new message when in[3]=1
            end else begin
                cnt <= cnt + 1'b1;  // Will automatically wrap from 2'b10 to 2'b00
            end
        end
    end

endmodule