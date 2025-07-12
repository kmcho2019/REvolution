module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        out <= 1;
    end else begin
        counter <= (counter == 7)? 0 : counter + 1;
        out <= 1 << counter; // Directly set the desired bit in out
    end
end

endmodule