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
reg EMPTY_REG, FULL_REG;

assign EMPTY = EMPTY_REG;
assign FULL = FULL_REG;

always @ (posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Clear the stack and reset the stack pointer on reset
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0;
            end
            SP <= 2'b11; // 4 in binary (indicating an empty buffer)
            EMPTY_REG <= 1'b1;
            FULL_REG <= 1'b0;
        end else begin
            // Perform push or pop operation
            if (~RW && ~FULL_REG) begin
                // Push data onto the stack
                stack_mem[SP] <= dataIn;
                if (SP == 2'b00) begin
                    FULL_REG <= 1'b1;
                end
                SP <= SP - 1'b1;
                EMPTY_REG <= 1'b0;
            end else if (RW && ~EMPTY_REG) begin
                // Pop data from the stack
                dataOut <= stack_mem[SP + 1'b1];
                stack_mem[SP + 1'b1] <= 4'b0;
                if (SP == 2'b10) begin
                    EMPTY_REG <= 1'b1;
                end
                SP <= SP + 1'b1;
                FULL_REG <= 1'b0;
            end
        end
    end
end

initial begin
    SP = 2'b11; // 4 in binary (indicating an empty buffer)
    EMPTY_REG = 1'b1;
    FULL_REG = 1'b0;
    for (int i = 0; i < 4; i++) begin
        stack_mem[i] = 4'b0;
    end
end

endmodule