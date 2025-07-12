module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire mux_result;

// Shared 2-to-1 mux logic
assign mux_result = (sel_b1 & sel_b2) ? b : a;

// Assign output using assign
assign out_assign = mux_result;

// Assign output using always block
always @(*) begin
    out_always = mux_result;
end

endmodule