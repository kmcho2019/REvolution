module top_module (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);
    wire mux_load_shift;
    wire mux_shift_hold;

    // First multiplexer: selects between loading R and shifting w
    assign mux_load_shift = L ? R : w;

    // Second multiplexer: selects between shifting/loading and holding Q
    assign mux_shift_hold = E ? mux_load_shift : Q;

    always @(posedge clk) begin
        Q <= mux_shift_hold;
    end
endmodule