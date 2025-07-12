module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*)
begin
    if (ena) 
        q <= d;
    // else do nothing, q retains its value
end

endmodule