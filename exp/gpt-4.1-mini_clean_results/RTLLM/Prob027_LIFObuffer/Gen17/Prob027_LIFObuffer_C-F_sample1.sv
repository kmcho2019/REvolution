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

    // Stack memory: 4 entries of 4 bits
    reg [3:0] stack_mem [3:0];
    // Stack Pointer: 3 bits, range 0..4; 4 means empty, 0 means full
    reg [2:0] SP;

    integer i;

    // Determine if push or pop operations are valid
    wire push_op = (EN && (RW == 1'b0) && (SP != 3'd0)); // can push if not full
    wire pop_op  = (EN && (RW == 1'b1) && (SP != 3'd4)); // can pop if not empty

    // Valid operation flag
    wire valid_op = push_op || pop_op;

    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;       // Initialize as empty
            dataOut <= 4'd0;
            // Clear stack memory on reset for known state
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (valid_op) begin
            if (push_op) begin
                // Push: decrement SP then write dataIn at new top (SP - 1)
                SP <= SP - 3'd1;
                stack_mem[SP - 3'd1] <= dataIn;
            end else if (pop_op) begin
                // Pop: read data from current top then increment SP
                dataOut <= stack_mem[SP];
                SP <= SP + 3'd1;
                // Avoid clearing memory on pop to reduce toggling
            end
        end
        // If no valid_op or EN low, hold all registers
    end

endmodule