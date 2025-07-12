module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] shift_reg;

always @(posedge clk) begin
    if (load) begin
        if (data == 0)
            shift_reg <= 0;
        else
            shift_reg <= 10'b1 << (data - 1);
    end else if (shift_reg != 0) begin
        shift_reg <= shift_reg >> 1;
    end
    // else hold zero
end

assign tc = (shift_reg == 0);

endmodule