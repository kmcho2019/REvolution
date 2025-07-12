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

reg [3:0] stack_mem [3:0]; // stack memory array
reg [1:0] SP; // stack pointer
reg [3:0] dataOut_reg; // register to hold output data

always @ (posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Reset the stack
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0;
            end
            SP <= 2'b100; // Initialize stack pointer to 4 (empty buffer)
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else begin
            if (!RW && (SP != 2'b100)) begin // Write operation
                // Push data onto the stack
                stack_mem[SP] <= dataIn;
                SP <= SP - 1'b1;
            end else if (RW && (SP != 2'b111)) begin // Read operation
                // Pop data from the stack
                dataOut_reg <= stack_mem[SP + 1'b1];
                stack_mem[SP + 1'b1] <= 4'b0; // Clear the popped memory location
                SP <= SP + 1'b1;
            end
            // Update EMPTY and FULL flags
            if (SP == 2'b100) begin
                EMPTY <= 1'b1;
                FULL <= 1'b0;
            end else if (SP == 2'b111) begin
                EMPTY <= 1'b0;
                FULL <= 1'b1;
            end else begin
                EMPTY <= 1'b0;
                FULL <= 1'b0;
            end
        end
    end
end

assign dataOut = dataOut_reg;

endmodule