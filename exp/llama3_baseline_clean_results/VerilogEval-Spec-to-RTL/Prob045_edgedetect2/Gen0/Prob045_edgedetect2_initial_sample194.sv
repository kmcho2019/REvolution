module TopModule(
    input               clk,
    input      [7:0]    in,
    output reg [7:0]    anyedge
);

reg [7:0] prev_in; // Store the previous state of the input vector

always @(posedge clk) begin
    anyedge <= ~in & prev_in | in & ~prev_in; // Detect any edge transition
    prev_in <= in; // Update the previous state for the next cycle
end

endmodule