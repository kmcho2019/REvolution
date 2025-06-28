module TopModule (
    input clk,
    input reset,
    output reg [3:1] ena,
    output reg [15:0] q
);

reg [13:0] counter = 14'b0000;
reg [3:0] ones, tens, hundreds, thousands;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 14'b0000;
        ones <= 4'b0000;
        tens <= 4'b0000;
        hundreds <= 4'b0000;
        thousands <= 4'b0000;
    end else begin
        // Increment the counter
        counter <= (counter == 14'b1001_0000_0000_0000) ? 14'b0000 : counter + 1;

        // Decode main counter value into BCD digits
        ones <= counter[3:0];
        tens <= counter[7:4];
        hundreds <= counter[11:8];
        thousands <= counter[13:12];

        // Update enable signals for the upper three digits
        ena = {0, counter[13:12]};
    end
end

assign q = {thousands, hundreds, tens, ones};

endmodule