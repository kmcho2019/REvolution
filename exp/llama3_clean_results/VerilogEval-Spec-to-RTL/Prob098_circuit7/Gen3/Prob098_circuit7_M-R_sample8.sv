module TopModule(
    input clk,
    input a,
    output reg q
);

initial q = 1; // Explicitly setting the initial state based on the waveform
always @(posedge clk) begin
    q <= ~a; // The core logic remains the same
end

endmodule