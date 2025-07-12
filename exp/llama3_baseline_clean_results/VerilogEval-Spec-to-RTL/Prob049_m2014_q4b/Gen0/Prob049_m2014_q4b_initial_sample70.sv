module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(*) begin
    if (ar) begin
        q <= 0;
    end else begin
        q <= d;
    end
end

// However, to make it a D flip flop, we need to add the clock sensitivity.
// But for Verilog, this would not be synthesizable, 
// because the always @(*) is for combinational logic.
// A proper implementation would be:
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 0;
    end else begin
        q <= d;
    end
end

endmodule