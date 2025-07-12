module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,            // Read/Write control signal (1 for read, 0 for write)
    input EN,            // Enable signal to activate buffer operations
    input Rst,           // Active high reset signal to initialize the buffer
    input Clk,           // Clock signal for synchronous operations
    output reg EMPTY,    // Flag indicating whether the buffer is empty
    output reg FULL,     // Flag indicating whether the buffer is full
    output reg [3:0] dataOut // 4-bit output data retrieved from the buffer
);

// Enumerations for buffer states
enum logic [1:0] {EMPTY Buf = 2'd3, PARTIAL = 2'd1, FULL Buf = 2'd0} buf_state;

reg [3:0] stack_mem[3:0]; // Stack memory
reg [1:0] SP;            // Stack pointer
reg [1:0] state;         // Buffer state

// Combinational logic for EMPTY and FULL flags
always @(*) begin
    case(state)
        EMPTY Buf: EMPTY = 1'b1;
        default: EMPTY = 1'b0;
    endcase
    case(state)
        FULL Buf: FULL = 1'b1;
        default: FULL = 1'b0;
    endcase
end

always @(posedge Clk) begin
    if (Rst) begin
        // Reset: Clear stack, set SP to 3 (indicating empty buffer), and initialize memory
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd3; // Initialize SP to indicate an empty buffer
        state <= EMPTY Buf;
        dataOut <= 4'd0;
    end else if (EN) begin
        case(state)
            EMPTY Buf: begin
                if (~RW) begin
                    // Write operation: Push data onto the stack
                    stack_mem[SP - 1] <= dataIn;
                    SP <= SP - 1; // Decrement SP
                    state <= PARTIAL;
                end
            end
            PARTIAL: begin
                if (~RW) begin
                    // Write operation: Push data onto the stack
                    stack_mem[SP - 1] <= dataIn;
                    SP <= SP - 1; // Decrement SP
                    if (SP == 2'd0) begin
                        state <= FULL Buf;
                    end
                end else if (RW) begin
                    // Read operation: Pop data from the stack
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0;
                    SP <= SP + 1; // Increment SP
                    if (SP == 2'd3) begin
                        state <= EMPTY Buf;
                    end
                end
            end
            FULL Buf: begin
                if (RW) begin
                    // Read operation: Pop data from the stack
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0;
                    SP <= SP + 1; // Increment SP
                    state <= PARTIAL;
                end
            end
        endcase
    end
end

endmodule