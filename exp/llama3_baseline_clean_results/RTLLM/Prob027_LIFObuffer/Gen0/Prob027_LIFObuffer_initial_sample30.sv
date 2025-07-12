module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output EMPTY,
    output FULL,
    output [3:0] dataOut
);

reg [3:0] stack_mem [0:3];
reg [1:0] SP;
reg EMPTY_reg, FULL_reg;

assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;

always @(*) begin
    if (SP == 4) begin
        EMPTY_reg = 1'b1;
        FULL_reg = 1'b0;
    end else if (SP == 0) begin
        EMPTY_reg = 1'b0;
        FULL_reg = 1'b1;
    end else begin
        EMPTY_reg = 1'b0;
        FULL_reg = 1'b0;
    end
end

always @(posedge Clk) begin
    if (Rst) begin
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
    end else if (EN) begin
        if (RW == 1'b0 && FULL_reg == 1'b0) begin
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW == 1'b1 && EMPTY_reg == 1'b0) begin
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

endmodule