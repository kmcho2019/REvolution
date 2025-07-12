module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

// Intermediate signal representing the selection condition
wire select_b = sel_b1 & sel_b2;

// Continuous assignment using the intermediate select_b signal
assign out_assign = select_b ? b : a;

always @(*) begin
    // Latch the selection condition into a local reg for demonstration
    reg sel_b_reg;
    sel_b_reg = select_b;
    
    if (sel_b_reg) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule