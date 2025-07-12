module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire enable_shift_load;
assign enable_shift_load = L || E;

wire d_input;
assign d_input = L ? R : w;

always @(posedge clk) begin
    if (enable_shift_load) begin
        Q <= d_input;
    end
end

endmodule