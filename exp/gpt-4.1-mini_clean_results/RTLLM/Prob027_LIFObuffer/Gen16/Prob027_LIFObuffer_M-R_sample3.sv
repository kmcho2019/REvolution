module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Stack memory: 4 entries, 4-bit each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer (SP):
    // SP counts down from 4 (empty) to 0 (full).
    // push: SP decreases (push at SP-1)
    // pop : SP increases (pop from SP)
    reg [2:0] SP; // 3-bit: values 0..4 (with 4 = empty)

    // Define push and pop operations combinationally
    wire push_op = EN && (RW == 1'b0) && (SP != 3'd0);
    wire pop_op  = EN && (RW == 1'b1) && (SP != 3'd4);

    // Next stack pointer calculation
    reg [2:0] next_SP;
    // Next dataOut calculation
    reg [3:0] next_dataOut;

    integer i;

    // Combinational logic for next state and output
    always @* begin
        next_SP = SP;
        next_dataOut = dataOut;

        if (Rst) begin
            next_SP = 3'd4;
            next_dataOut = 4'd0;
        end else if (push_op) begin
            next_SP = SP - 3'd1;
            // dataOut unchanged on push
            next_dataOut = dataOut;
        end else if (pop_op) begin
            next_SP = SP + 3'd1;
            // dataOut updated with current top of stack
            next_dataOut = stack_mem[SP];
        end
        // else no operation, hold current SP and dataOut
    end

    // Sequential logic for SP and dataOut update
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'd0;
        end else begin
            SP <= next_SP;
            dataOut <= next_dataOut;
        end
    end

    // Write enables for each stack memory entry
    // Write occurs only on push_op, to the address SP - 1
    genvar idx;
    generate
        for (idx = 0; idx < 4; idx = idx + 1) begin : stack_write_block
            always @(posedge Clk) begin
                if (Rst) begin
                    stack_mem[idx] <= 4'd0;
                end else if (push_op && ((SP - 3'd1) == idx)) begin
                    stack_mem[idx] <= dataIn;
                end
                // No clearing on pop to save power
            end
        end
    endgenerate

    // Flags combinational from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule