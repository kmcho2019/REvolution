module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] cnt;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        cnt <= 3'b000; // Reset counter to 0
    end else begin
        // Increment counter, wrapping around to 0 after 7
        if (cnt == 3'b111) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

// Generate output based on counter value
assign out = (1 << cnt);

endmodule