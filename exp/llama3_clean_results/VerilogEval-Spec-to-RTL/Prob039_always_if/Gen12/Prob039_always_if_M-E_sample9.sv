module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

logic control_signal;
assign control_signal = sel_b1 && sel_b2;

// Unified logic block for direct assignment and procedural assignment
assign out_assign = control_signal ? b : a;

always @(*) begin
    if (control_signal) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule