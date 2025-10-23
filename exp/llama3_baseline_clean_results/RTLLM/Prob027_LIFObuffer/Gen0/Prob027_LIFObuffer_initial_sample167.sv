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

reg [3:0] stack_mem [3:0]; // 4x4 stack memory array
reg [1:0] SP; // Stack pointer
reg EMPTY_reg, FULL_reg; // EMPTY and FULL flags
reg [3:0] dataOut_reg; // Output data register

// Initialize stack pointer and flags
initial begin
    SP = 4;
    EMPTY_reg = 1'b1;
    FULL_reg = 1'b0;
end

// Update stack pointer, flags, and dataOut on rising edge of clock
always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin // Reset stack and flags
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0;
            end
            SP <= 4;
            EMPTY_reg <= 1'b1;
            FULL_reg <= 1'b0;
        end else begin // Process data
            if (RW == 1'b0 && SP!= 0) begin // Push data onto stack (write operation)
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
            end else if (RW == 1'b1 && SP!= 4) begin // Pop data from stack (read operation)
                dataOut_reg <= stack_mem[SP];
                stack_mem[SP] <= 4'b0;
                SP <= SP + 1;
            end
        end
    end
    // Update EMPTY and FULL flags
    if (SP == 4) begin
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

// Assign output signals
assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;
assign dataOut = dataOut_reg;

endmodule