module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg out_assign,
    output reg out_always
);

// Priority encoding
wire priority_b;
assign priority_b = sel_b1 && sel_b2;

// Continuous assignment with priority
assign out_assign = (priority_b)? b : a;

// Procedural assignment with priority
always @(*) begin
    if (priority_b) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule