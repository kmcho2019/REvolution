module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

wire selected;

always @(*) begin
    if (sel)
        selected = b;
    else
        selected = a;
end

assign out = selected;

endmodule