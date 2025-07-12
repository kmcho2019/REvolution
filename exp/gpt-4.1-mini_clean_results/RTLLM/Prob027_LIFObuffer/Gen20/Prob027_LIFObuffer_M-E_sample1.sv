module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,          // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Stack memory: 4 entries, each 4-bit wide
    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // stack pointer: number of elements in stack (0 to 4)

    // Internal signals for operation enable and next_SP calculation
    wire push_en = EN && (RW == 1'b0) && (SP < 3'd4);
    wire pop_en  = EN && (RW == 1'b1) && (SP > 3'd0);

    wire [2:0] next_SP = push_en ? (SP + 3'd1) :
                         pop_en  ? (SP - 3'd1) :
                                   SP;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            if (push_en) begin
                stack_mem[SP] <= dataIn;  // write at current SP position
                SP <= next_SP;
            end else if (pop_en) begin
                SP <= next_SP;
                dataOut <= stack_mem[next_SP]; // output the popped value (SP - 1)
                // No clearing of stack_mem to save toggling; contents are overwritten on push
            end
        end
    end

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule