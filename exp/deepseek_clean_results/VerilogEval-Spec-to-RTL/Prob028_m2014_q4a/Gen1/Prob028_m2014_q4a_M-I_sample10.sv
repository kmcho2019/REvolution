module TopModule (
    input d,
    input ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q = d;  // Use blocking assignment for combinational logic
    end
end

endmodule