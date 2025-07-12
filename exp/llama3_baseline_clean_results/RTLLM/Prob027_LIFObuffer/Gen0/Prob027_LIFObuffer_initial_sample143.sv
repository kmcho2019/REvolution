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

parameter DATA_WIDTH = 4;
parameter STACK_SIZE = 4;

reg [DATA_WIDTH-1:0] stack_mem [STACK_SIZE-1:0];
reg [STACK_SIZE-1:0] SP;
reg EMPTY_reg;
reg FULL_reg;

assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and set the stack pointer to STACK_SIZE (indicating an empty buffer)
        for (int i = 0; i < STACK_SIZE; i++) begin
            stack_mem[i] <= 0;
        end
        SP <= STACK_SIZE;
        EMPTY_reg <= 1'b1;
        FULL_reg <= 1'b0;
    end else if (EN) begin
        // Check for push operation
        if (~RW && ~FULL_reg) begin
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end
        // Check for pop operation
        else if (RW && ~EMPTY_reg) begin
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 0;
            SP <= SP + 1;
        end
    end
end

// Update the EMPTY and FULL flags
always @(SP) begin
    if (SP == STACK_SIZE) begin
        EMPTY_reg <= 1'b1;
        FULL_reg <= 1'b0;
    end else if (SP == 0) begin
        EMPTY_reg <= 1'b0;
        FULL_reg <= 1'b1;
    end else begin
        EMPTY_reg <= 1'b0;
        FULL_reg <= 1'b0;
    end
end

endmodule