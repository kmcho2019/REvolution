module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

reg [1:0] mode_counter = 0;
reg out_assign_reg;
reg out_alwaysblock_reg;

always @(*) begin
    out_assign_reg = a & b;
    out_alwaysblock_reg = a & b;
end

always @(posedge a or posedge b) begin
    if (mode_counter == 0) begin
        out_assign <= out_assign_reg;
        out_alwaysblock <= 1'b0;
    end else begin
        out_assign <= 1'b0;
        out_alwaysblock <= out_alwaysblock_reg;
    end
    mode_counter <= mode_counter + 1;
    if (mode_counter == 2) begin
        mode_counter <= 0;
    end
end

assign out_assign = out_assign;
assign out_alwaysblock = out_alwaysblock;

endmodule