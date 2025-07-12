module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Stack memory: 4 entries of 4-bit data
    reg [3:0] stack_mem [3:0];
    // Stack pointer (SP): 0..4 (3 bits)
    // SP = 4 means empty; SP = 0 means full
    reg [2:0] SP;

    // Push enabled if EN=1, RW=0 (write), and not full
    wire push_en = EN && (RW == 1'b0) && (SP != 3'd0);
    // Pop enabled if EN=1, RW=1 (read), and not empty
    wire pop_en  = EN && (RW == 1'b1) && (SP != 3'd4);

    // Precompute push and pop addresses
    wire [2:0] push_addr = SP - 3'd1; // address to push (new top)
    wire [2:0] pop_addr  = SP;        // address to pop (current top)

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;        // Initialize empty stack pointer
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;  // Clear stack memory on reset
        end else begin
            if (push_en) begin
                // Push operation: write dataIn at push_addr, decrement SP
                stack_mem[push_addr] <= dataIn;
                SP <= SP - 3'd1;
            end else if (pop_en) begin
                // Pop operation: output data at pop_addr, increment SP
                dataOut <= stack_mem[pop_addr];
                // Memory clearing skipped for power saving
                SP <= SP + 3'd1;
            end
            // If no push or pop, keep SP and dataOut unchanged
        end
    end

    // Combinational flags derived from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule