module TopModule(
    input  d,
    input  ena,
    output reg q = 1'b0 // Initialize q with a default value
);

always @(*) begin
    q <= ena? d : q;
end

endmodule