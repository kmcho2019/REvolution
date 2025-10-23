module TopModule (
    input d,
    input ena,
    output reg q
);

always @ (d or ena) begin
    if (ena)
        q = d;
    // else hold the previous state, so no assignment
end

endmodule