module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

// Using continuous assignment for simplicity and potential better synthesis
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Using procedural if statement in an always block for out_always
always @(*) begin
    if (sel_b1 && sel_b2) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule