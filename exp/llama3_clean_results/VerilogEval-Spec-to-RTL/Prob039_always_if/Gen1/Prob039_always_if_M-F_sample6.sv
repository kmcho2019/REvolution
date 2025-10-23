module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg out_assign,  // Declare as reg for procedural assignment
    output reg out_always   // Declare as reg for procedural assignment
);

// Continuous assignment for the first multiplexer
assign out_assign = (sel_b1 && sel_b2)? b : a;

// Procedural if statement for the second multiplexer
always @(*) begin
    if (sel_b1 && sel_b2) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule