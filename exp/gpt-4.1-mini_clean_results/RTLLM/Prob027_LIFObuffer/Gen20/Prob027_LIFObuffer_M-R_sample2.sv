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
    reg [3:0] stack_mem [0:3];
    reg [2:0] SP;  // Stack pointer: 4 means empty, 0 means full

    integer i;

    // Synchronous operations for push/pop and reset
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;        // Empty stack pointer
            dataOut <= 4'd0;   // Clear output on reset
            // Do NOT clear stack_mem to reduce switching power
        end else if (EN) begin
            if ((RW == 1'b0) && (SP != 3'd0)) begin
                // Push operation: decrement SP and store dataIn
                SP <= SP - 3'd1;
                stack_mem[SP - 3'd1] <= dataIn;
            end else if ((RW == 1'b1) && (SP != 3'd4)) begin
                // Pop operation: read from stack_mem, clear that entry, increment SP
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'd0;
                SP <= SP + 3'd1;
            end else begin
                // No change in SP or stack_mem or dataOut if conditions not met
                dataOut <= dataOut;
                SP <= SP;
            end
        end
    end

    // Combinational assignments for flags
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule