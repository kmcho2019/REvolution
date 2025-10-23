module LIFObuffer(
    input [3:0] dataIn,
    input RW, EN, Rst, Clk,
    output EMPTY, FULL,
    output [3:0] dataOut
);

reg [3:0] stack_mem [3:0]; // Stack memory array
reg [1:0] SP; // Stack pointer
reg EMPTY, FULL; // Flags for empty and full conditions
reg [3:0] dataOut_reg; // Register for output data

// Reset and clock edge operations
always @(posedge Clk) begin
    if (Rst) begin
        // Clear stack memory, set stack pointer to 4 (empty), and reset flags
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 0;
        end
        SP <= 2'd4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        // Push data onto the stack if not full and RW is low
        if (!RW && !FULL) begin
            stack_mem[SP] <= dataIn;
            SP <= SP - 1'b1;
        end
        // Pop data from the stack if not empty and RW is high
        else if (RW && !EMPTY) begin
            dataOut_reg <= stack_mem[SP + 1'b1];
            stack_mem[SP + 1'b1] <= 0;
            SP <= SP + 1'b1;
        end
    end
end

// Update flags based on stack pointer status
always @(*) begin
    if (SP == 2'd4) begin
        EMPTY = 1'b1;
        FULL = 1'b0;
    end else if (SP == 2'd0) begin
        EMPTY = 1'b0;
        FULL = 1'b1;
    end else begin
        EMPTY = 1'b0;
        FULL = 1'b0;
    end
end

// Assign output data based on stack pointer and memory content
always @(*) begin
    if (!EMPTY) begin
        dataOut = stack_mem[SP + 1'b1];
    end else begin
        dataOut = 0;
    end
end

assign dataOut = dataOut_reg;

endmodule