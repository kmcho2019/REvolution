module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,        // Active high synchronous reset
    input  wire        EN,         // Enable for operations
    input  wire        RW,         // Read/Write control: 0 = push (write), 1 = pop (read)
    input  wire [3:0]  dataIn,     // Data input for push
    output wire        EMPTY,      // High when buffer is empty
    output wire        FULL,       // High when buffer is full
    output reg  [3:0]  dataOut     // Data output for pop
);

    // Stack memory: 4 entries, each 4-bit wide
    reg [3:0] stack_mem [3:0];

    // Stack pointer SP:
    // Range: 0..4
    // SP == 4 means buffer empty (top index invalid)
    // SP == 0 means buffer full (4 entries occupied)
    reg [2:0] SP;

    // Control signals for push and pop operations
    wire push_en = EN && (RW == 1'b0) && (SP != 3'd0);
    wire pop_en  = EN && (RW == 1'b1) && (SP != 3'd4);

    // Addresses for push and pop operations
    wire [2:0] push_addr = SP - 3'd1; // Address to push new data (next top)
    wire [2:0] pop_addr  = SP;        // Address to pop data (current top)

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset stack pointer to empty and clear memory
            SP <= 3'd4;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            if (push_en) begin
                // Push operation: decrement SP and write dataIn at push_addr
                stack_mem[push_addr] <= dataIn;
                SP <= SP - 3'd1;
            end else if (pop_en) begin
                // Pop operation: read data at pop_addr into dataOut, increment SP
                dataOut <= stack_mem[pop_addr];
                SP <= SP + 3'd1;
                // Memory clearing skipped to save power
            end
            // If no operation or EN low, hold current state (no toggling)
        end
    end

    // Combinational flags derived from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule