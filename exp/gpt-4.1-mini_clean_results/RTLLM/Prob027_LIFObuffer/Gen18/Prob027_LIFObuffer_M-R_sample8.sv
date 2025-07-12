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
    // Counts number of valid entries in stack: 0 = empty, 4 = full
    reg [2:0] SP;

    // Push and Pop condition wires
    wire push_op = EN && (RW == 1'b0) && (SP < 3'd4);
    wire pop_op  = EN && (RW == 1'b1) && (SP > 3'd0);

    // Next state logic for SP
    reg [2:0] SP_next;

    // Register for pop read address to separate read from SP update
    reg [2:0] pop_addr;

    // Combinational block to determine next SP and pop_addr
    always @(*) begin
        SP_next = SP;
        pop_addr = 3'd0;

        if (push_op) begin
            // Push increases SP by 1
            SP_next = SP + 3'd1;
        end else if (pop_op) begin
            // Pop decreases SP by 1
            SP_next = SP - 3'd1;
            pop_addr = SP - 3'd1;
        end
    end

    // Sequential block to update SP, stack_mem, and dataOut
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // Not clearing stack_mem to reduce complexity; not functionally necessary
        end else begin
            SP <= SP_next;

            if (push_op) begin
                stack_mem[SP] <= dataIn;
            end

            if (pop_op) begin
                dataOut <= stack_mem[pop_addr];
                stack_mem[pop_addr] <= 4'd0;
            end
        end
    end

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule