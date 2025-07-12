module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [0:3];

    // Stack Pointer (SP):
    // Counts down from 4 (empty) to 0 (full)
    // push: SP decrements, push at SP-1
    // pop:  SP increments, pop from SP
    reg [2:0] SP;

    // Combinational push and pop enables
    wire push_en = EN && (RW == 1'b0) && (SP != 3'd0);
    wire pop_en  = EN && (RW == 1'b1) && (SP != 3'd4);

    // Calculate next SP combinationally
    reg [2:0] next_SP;
    // Next dataOut, updated only on pop
    reg [3:0] next_dataOut;

    // Address to push data (valid only if push_en)
    wire [2:0] push_addr = SP - 3'd1;

    integer i;

    // Next-state logic for SP and dataOut
    always @(*) begin
        if (Rst) begin
            next_SP = 3'd4;        // Empty stack
            next_dataOut = 4'd0;
        end else if (push_en) begin
            next_SP = SP - 3'd1;
            next_dataOut = dataOut; // No change on push
        end else if (pop_en) begin
            next_SP = SP + 3'd1;
            next_dataOut = stack_mem[SP];
        end else begin
            next_SP = SP;
            next_dataOut = dataOut;
        end
    end

    // Sequential logic: update SP, dataOut, stack_mem
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            SP <= next_SP;
            dataOut <= next_dataOut;

            if (push_en) begin
                stack_mem[push_addr] <= dataIn;
            end
            // Do not clear stack_mem on pop to save power
        end
    end

    // Flags for empty and full
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule