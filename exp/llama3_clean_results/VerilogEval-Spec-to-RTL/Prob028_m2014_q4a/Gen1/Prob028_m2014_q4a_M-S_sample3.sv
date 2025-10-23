module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) 
        q = d;
    else
        q = q; // retain the previous value when ena is low
end

endmodule