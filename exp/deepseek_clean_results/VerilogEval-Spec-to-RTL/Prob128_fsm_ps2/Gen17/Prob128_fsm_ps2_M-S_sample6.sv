module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt; // 0-2 counter for message bytes
    reg counting;  // 1 when in message, 0 when idle

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b00;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            done <= (cnt == 2'b10); // Done after 3rd byte
            
            if (counting) begin
                cnt <= cnt + 1;     // Count message bytes
                if (cnt == 2'b10)   // After 3 bytes
                    counting <= 1'b0; // Return to idle
            end else if (in[3]) begin
                counting <= 1'b1;   // Start new message
                cnt <= 2'b00;
            end
        end
    end

endmodule