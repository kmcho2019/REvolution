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

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;   // Stack Pointer: 0..4, with 4 meaning empty

    // Single valid operation flag: 1 if push or pop happens this cycle
    reg valid_op;
    reg pop_op;

    integer i;

    // Combinational logic for next_SP and valid_op determination
    // Also determines if operation is pop or push
    wire push_op  = (EN && (RW == 1'b0) && (SP != 3'd0)); // push if not full
    wire pop_op_w = (EN && (RW == 1'b1) && (SP != 3'd4)); // pop if not empty

    wire [2:0] next_SP = (push_op) ? (SP - 3'd1) :
                        (pop_op_w) ? (SP + 3'd1) : SP;

    always @(*) begin
        valid_op = push_op | pop_op_w;
        pop_op = pop_op_w;
    end

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4; // empty stack pointer
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (valid_op) begin
            SP <= next_SP;

            if (push_op) begin
                // Push at SP - 1 (new top)
                stack_mem[SP - 3'd1] <= dataIn;
            end else if (pop_op) begin
                // Pop returns data from current SP position before increment
                dataOut <= stack_mem[SP];
                // Memory clearing skipped for power saving
            end
        end
        // If no valid_op, registers hold their values, reducing toggling
    end

    // Flags derived combinationally from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule