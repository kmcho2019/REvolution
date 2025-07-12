module TopModule (
    input d,
    input ena,
    output reg q
);

always @* begin
    if (ena) q = d;
    // q retains its value when ena is low
end

endmodule