module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output wire out_assign, // Using wire for combinational assignment
    output logic out_always // Using logic for procedural assignment
);

// Combinational logic using assign statement
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Procedural assignment using if statement
always @(*) begin
    if (sel_b1 && sel_b2) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule