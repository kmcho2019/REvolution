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

reg [3:0] stack_mem[0:3]; // stack memory array
reg [1:0] SP; // stack pointer
reg EMPTY_reg; // EMPTY flag register
reg FULL_reg; // FULL flag register
reg [3:0] dataOut_reg; // dataOut register

// Initialize stack pointer and flags
initial begin
    SP = 4;
    EMPTY_reg = 1;
    FULL_reg = 0;
end

// Update stack memory, stack pointer, and flags on clock edge
always @(posedge Clk) begin
    if (Rst) begin // Reset operation
        SP = 4;
        EMPTY_reg = 1;
        FULL_reg = 0;
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] = 0;
        end
    end else if (EN) begin // Enable signal is high
        if (RW) begin // Read operation
            if (SP != 4) begin // Buffer is not empty
                dataOut_reg = stack_mem[SP];
                stack_mem[SP] = 0;
                SP = SP + 1;
                if (SP == 4) begin // Update EMPTY flag
                    EMPTY_reg = 1;
                end
                FULL_reg = 0;
            end else begin // Buffer is empty
                dataOut_reg = 0;
            end
        end else begin // Write operation
            if (SP != 0) begin // Buffer is not full
                SP = SP - 1;
                stack_mem[SP] = dataIn;
                if (SP == 0) begin // Update FULL flag
                    FULL_reg = 1;
                end
                EMPTY_reg = 0;
            end else begin // Buffer is full
                // Do nothing
            end
        end
    end
end

// Assign output ports
assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;
assign dataOut = dataOut_reg;

endmodule