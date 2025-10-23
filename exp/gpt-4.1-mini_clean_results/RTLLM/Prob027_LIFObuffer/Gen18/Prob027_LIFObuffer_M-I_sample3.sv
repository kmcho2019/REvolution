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

    // Stack pointer (SP): indicates number of valid entries (0 to 4)
    // SP=0 means empty, SP=4 means full
    reg [2:0] SP;

    wire push_en = EN && (RW == 1'b0) && (SP != 3'd4);
    wire pop_en  = EN && (RW == 1'b1) && (SP != 3'd0);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;           // Empty stack
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;  // Clear stack memory
        end else begin
            if (push_en) begin
                // Push dataIn at position SP (current top)
                stack_mem[SP] <= dataIn;
                SP <= SP + 3'd1;  // Increment SP after push
            end else if (pop_en) begin
                // Pop from position SP-1 (top element)
                SP <= SP - 3'd1;  // Decrement SP before pop read
                dataOut <= stack_mem[SP - 3'd1];
                // Do not clear memory on pop for power saving
            end
            // else hold values (no toggling)
        end
    end

    // Flags combinationally derived from SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule