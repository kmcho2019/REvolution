module TopModule(
    input clk,
    input a,
    output reg q = 1'b1 // Initial output q is 1, as seen in the waveform
);

always @(posedge clk) begin
    if (a) begin // When a is high at the positive edge of the clock
        q <= ~q; // Toggle the output q
    end
end

endmodule