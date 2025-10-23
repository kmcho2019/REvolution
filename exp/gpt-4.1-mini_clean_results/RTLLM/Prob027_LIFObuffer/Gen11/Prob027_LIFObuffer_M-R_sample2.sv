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
    // Stack pointer: counts number of available entries from top
    // SP=4 means empty, SP=0 means full
    reg [2:0] SP;

    // Derived signals for push and pop enables
    wire push_en = EN && (RW == 1'b0) && (SP != 3'd0);
    wire pop_en  = EN && (RW == 1'b1) && (SP != 3'd4);

    // Addresses for push and pop operations
    // Push writes at SP-1 (top of stack before decrement)
    wire [2:0] push_addr = SP - 3'd1;
    // Pop reads at SP (top of stack before increment)
    wire [2:0] pop_addr  = SP;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4; // empty stack
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            if (push_en) begin
                // Push dataIn at stack_mem[SP-1], decrement SP
                stack_mem[push_addr] <= dataIn;
                SP <= SP - 3'd1;
            end else if (pop_en) begin
                // Pop data from stack_mem[SP], increment SP
                dataOut <= stack_mem[pop_addr];
                // Clearing memory location is optional; skip for power saving
                SP <= SP + 3'd1;
            end
            // If no push or pop, hold SP and dataOut
        end
    end

    // Flags combinationally assigned
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule