module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

// Generate the gated clock signal
wire clk_gated;
assign clk_gated = sel_b1 && sel_b2;

// Implement the multiplexer using combinational logic
wire mux_out;
assign mux_out = (sel_b1 && sel_b2) ? b : a;

// Use a Level-Sensitive Latch (LSL) to store the output of the multiplexer
reg out_always_reg;
always @(*) begin
    if (clk_gated) begin
        out_always_reg <= mux_out;
    end
end

// Assign the output of the LSL to the out_always port
assign out_always = out_always_reg;

// Assign the output of the multiplexer to the out_assign port
assign out_assign = mux_out;

endmodule