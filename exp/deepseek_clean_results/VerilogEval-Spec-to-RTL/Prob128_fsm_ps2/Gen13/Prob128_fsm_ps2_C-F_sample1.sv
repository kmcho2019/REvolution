module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;
    reg in_message;  // Track if we're in a message to reduce power

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
            in_message <= 1'b0;
        end else begin
            done <= (cnt == 2'b10);  // Assert done when third byte is received
            
            if (in_message) begin
                cnt <= (cnt == 2'b10) ? 2'b0 : cnt + 1'b1;
                in_message <= (cnt != 2'b10);  // Clear when message complete
            end else if (in[3]) begin
                cnt <= 2'b01;  // Start new message
                in_message <= 1'b1;
            end
        end
    end

endmodule