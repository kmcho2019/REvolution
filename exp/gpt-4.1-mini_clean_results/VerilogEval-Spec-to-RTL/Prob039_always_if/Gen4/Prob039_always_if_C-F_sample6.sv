module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

wire use_b = sel_b1 & sel_b2;

// Continuous assignment implementing the 2-to-1 mux using the intermediate signal
assign out_assign = use_b ? b : a;

always @(*) begin
    // Procedural implementation using the intermediate signal with if-else
    if (use_b) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule