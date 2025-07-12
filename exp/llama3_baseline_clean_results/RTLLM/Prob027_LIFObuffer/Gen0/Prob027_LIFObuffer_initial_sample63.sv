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
reg EMPTY_reg;
reg FULL_reg;

assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;

always @(posedge Clk) begin
    if (Rst) begin
        SP <= 4;
        EMPTY_reg <= 1'b1;
        FULL_reg <= 1'b0;
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
    end else if (EN) begin
        if (~RW && ~FULL_reg) begin // Write operation
            stack_mem[SP] <= dataIn;
            SP <= SP - 1;
            EMPTY_reg <= 1'b0;
            if (SP == 0) begin
                FULL_reg <= 1'b1;
            end
        end else if (RW && ~EMPTY_reg) begin // Read operation
            dataOut <= stack_mem[SP + 1];
            stack_mem[SP + 1] <= 4'b0;
            SP <= SP + 1;
            FULL_reg <= 1'b0;
            if (SP == 3) begin
                EMPTY_reg <= 1'b1;
            end
        end
    end
end

endmodule