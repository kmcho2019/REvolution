module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg state; // Internal state variable

always @(posedge clk or posedge ar)
begin
    if (ar) // Asynchronous reset condition
        state <= 1'b0;
    else if (clk) // Positive edge of the clock
        state <= d;
    q <= state; // Output follows the internal state
end

endmodule