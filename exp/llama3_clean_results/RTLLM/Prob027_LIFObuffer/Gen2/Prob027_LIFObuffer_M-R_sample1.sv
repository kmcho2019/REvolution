module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

// Stack memory to store data
reg [3:0] stack_mem [0:3];

// Stack pointer to track current position
reg [1:0] SP;

// Initialize flags
always @(*) begin
    EMPTY = (SP == 3);
    FULL = (SP == 0);
end

// Sequential logic for the stack operations
always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 3;
    end else if (EN) begin
        case ({RW, FULL, EMPTY})
            3'b000: begin // RW = 0 (write), FULL = 0, EMPTY = 0
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
            end
            3'b100: begin // RW = 1 (read), FULL = 0, EMPTY = 0
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'b0;
                SP <= SP + 1;
            end
            default: begin
                // No operation
            end
        endcase
    end
end

endmodule