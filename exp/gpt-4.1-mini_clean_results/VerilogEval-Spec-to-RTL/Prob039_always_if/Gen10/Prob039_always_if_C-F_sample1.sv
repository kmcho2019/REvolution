module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire use_b = sel_b1 & sel_b2;
wire mux_result = use_b ? b : a;

assign out_assign = mux_result;

always @(*) begin
    if (use_b) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule