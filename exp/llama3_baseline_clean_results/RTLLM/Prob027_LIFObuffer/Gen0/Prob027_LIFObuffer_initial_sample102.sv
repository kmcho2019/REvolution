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

reg [3:0] stack_mem [3:0];
reg [1:0] SP;
reg EMPTY_reg;
reg FULL_reg;

always @ (posedge Clk) begin
    if (Rst) begin
        // Reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4;
        EMPTY_reg <= 1'b1;
        FULL_reg <= 1'b0;
    end else if (EN) begin
        // Check if the buffer is full or empty
        if (RW == 1'b0 && !FULL_reg) begin
            // Push data onto the stack (write operation)
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1'b1;
        end else if (RW == 1'b1 && !EMPTY_reg) begin
            // Pop data from the stack (read operation)
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1'b1;
        end
    end
end

// Update EMPTY and FULL flags
always @ (posedge Clk) begin
    if (Rst) begin
        EMPTY_reg <= 1'b1;
        FULL_reg <= 1'b0;
    end else if (EN) begin
        if (SP == 2'd4) begin
            EMPTY_reg <= 1'b1;
        end else if (SP == 2'd0) begin
            FULL_reg <= 1'b1;
        end else begin
            EMPTY_reg <= 1'b0;
            FULL_reg <= 1'b0;
        end
    end
end

assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;

endmodule