module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write (push), 1: read (pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer: values 0 to 4 inclusive; 
    // SP == 4 means empty; SP == 0 means full
    reg [2:0] SP;

    integer i;

    // Internal variables for next SP and mem index to avoid read-after-write issues
    reg [2:0] next_SP;
    reg [1:0] mem_index;  // 2 bits since max index is 3

    // Combinational EMPTY and FULL flags derived from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset stack pointer and memory
            SP <= 3'd4;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) operation: only if not full
                if (SP != 3'd0) begin
                    // Calculate new stack pointer and write index before update
                    next_SP = SP - 1;
                    mem_index = next_SP[1:0];
                    stack_mem[mem_index] <= dataIn;
                    SP <= next_SP;
                end
                // else full: no operation
            end else begin
                // Read (pop) operation: only if not empty
                if (SP != 3'd4) begin
                    mem_index = SP[1:0];      // Current top element index
                    dataOut <= stack_mem[mem_index];
                    // Do NOT clear memory to reduce switching
                    SP <= SP + 1;
                end
                // else empty: no operation, dataOut unchanged
            end
        end
        // If EN low: no operation, state held
    end

endmodule