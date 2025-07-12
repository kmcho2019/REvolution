module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q = d;
    end else begin
        // No need to explicitly assign q when ena is low, 
        // the reg will retain its value by default
    end
end

endmodule