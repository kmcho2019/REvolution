module TopModule(
    input clk, 
    input w, 
    input R, 
    input E, 
    input L, 
    output Q
);

reg q;

always @(posedge clk)
begin
    if (L)
        q <= R;
    else if (E)
        q <= w;
end

assign Q = q;

endmodule