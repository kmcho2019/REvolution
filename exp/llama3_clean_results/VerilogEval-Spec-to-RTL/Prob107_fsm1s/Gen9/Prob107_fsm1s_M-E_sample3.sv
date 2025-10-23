module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] counter; // Using a 2-bit register to represent the counter

always @(posedge clk) begin
    if(reset) begin
        counter <= 2'b11; // Reset state is B, represented by maximum counter value
    end else begin
        if(in == 0 && counter > 0) begin
            counter <= counter - 1; // Decrement counter when in is 0
        end
    end
end

assign out = (counter == 2'b11) ? 1'b1 : 1'b0; // Output is 1 when counter is at its maximum value (state B)

endmodule