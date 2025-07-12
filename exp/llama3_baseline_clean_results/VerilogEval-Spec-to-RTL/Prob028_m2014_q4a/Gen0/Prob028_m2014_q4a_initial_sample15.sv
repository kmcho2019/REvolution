module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*)
begin
    if (ena)
        q <= d;
    // else q will hold its previous value
end

endmodule