module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (q == 0 && a == 0)
        q <= 1;
    else if (q == 1 && a == 1)
        q <= 0;
    else
        q <= q; // Hold current value
end

initial begin
    q = 1'bx; // Unknown initial state to match waveform at time 0
end

endmodule