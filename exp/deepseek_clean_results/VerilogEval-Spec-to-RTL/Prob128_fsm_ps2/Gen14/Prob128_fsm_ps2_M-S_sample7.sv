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
            done <= (cnt == 2'b10);  // Assert done when third byte received
            
            if (cnt == 0) begin
                if (in[3]) cnt <= cnt + 1'b1;  // Start counting on first byte
            end else begin
                if (cnt == 2'b10) cnt <= 2'b0;  // Reset after third byte
                else cnt <= cnt + 1'b1;         // Increment otherwise
            end
        end
    end

endmodule