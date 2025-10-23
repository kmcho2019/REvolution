module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Stack memory: 4 entries of 4 bits
    reg [3:0] stack_mem [0:3];

    // Stack pointer (SP):
    // SP ranges from 4 (empty) down to 0 (full)
    // push: SP = SP - 1, data written at stack_mem[SP - 1]
    // pop:  dataOut from stack_mem[SP], then SP = SP + 1
    reg [2:0] SP; // values 0..4

    // Push and pop enable signals
    wire push_en = EN && (RW == 1'b0) && (SP != 3'd0);
    wire pop_en  = EN && (RW == 1'b1) && (SP != 3'd4);

    // next_SP calculation
    wire [2:0] next_SP = push_en ? (SP - 3'd1) :
                         pop_en  ? (SP + 3'd1) :
                                   SP;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;         // Initialize stack as empty
            dataOut <= 4'd0;    // Clear output data
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;  // Clear stack memory
        end else if (push_en || pop_en) begin
            SP <= next_SP;

            if (push_en) begin
                // Push dataIn onto stack_mem at SP-1 (new top)
                stack_mem[SP - 3'd1] <= dataIn;
                // dataOut not updated on push
            end else if (pop_en) begin
                // Pop data from stack_mem[SP] to dataOut
                dataOut <= stack_mem[SP];
                // Skip clearing stack_mem[SP] to save power
            end
        end
        // If EN=0 or no valid push/pop, hold all registers
    end

    // EMPTY and FULL flags combinationally derived from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule