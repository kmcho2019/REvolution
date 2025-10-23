module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,        // Active high reset
    input  wire        EN,         // Enable signal
    input  wire        RW,         // 0: write (push), 1: read (pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Stack memory: 4 entries, 4 bits each
    reg [3:0] stack_mem [3:0];
    // Stack Pointer: counts how many elements are stored (0 to 4)
    reg [2:0] SP;

    // Combinational push and pop enables
    wire push_en = EN && (RW == 1'b0) && (SP < 3'd4);
    wire pop_en  = EN && (RW == 1'b1) && (SP > 3'd0);

    // Push writes at stack_mem[SP] (next free position)
    wire [2:0] push_addr = SP;
    // Pop reads at stack_mem[SP-1] (top element)
    wire [2:0] pop_addr = SP - 3'd1;

    integer i;

    // Flags: empty if SP==0, full if SP==4
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // Clear stack memory at reset for deterministic state
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (EN) begin
            if (push_en) begin
                stack_mem[push_addr] <= dataIn;
                SP <= SP + 3'd1;
                // dataOut holds its value on push
            end else if (pop_en) begin
                dataOut <= stack_mem[pop_addr];
                SP <= SP - 3'd1;
                // Do not clear popped memory location to reduce toggling
            end
            // else no operation on EN
        end
        // else EN=0: hold SP and dataOut values
    end

endmodule