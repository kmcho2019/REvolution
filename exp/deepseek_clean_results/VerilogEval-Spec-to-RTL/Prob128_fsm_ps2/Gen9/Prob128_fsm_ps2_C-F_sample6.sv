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
            // Assert done in cycle after third byte is received
            done <= (cnt == 2'b10);
            
            // State transition logic
            if (cnt == 2'b0) begin
                // Wait for start byte (in[3]=1)
                if (in[3]) cnt <= 2'b01;
            end else begin
                // Progress through message bytes
                cnt <= (cnt == 2'b10) ? 2'b0 : cnt + 1'b1;
            end
        end
    end

endmodule