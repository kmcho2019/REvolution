module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q = d;
    end else begin
        // No need to explicitly assign q to its previous value in Verilog
        // because the reg type will retain its value until it's reassigned
    end
end

endmodule