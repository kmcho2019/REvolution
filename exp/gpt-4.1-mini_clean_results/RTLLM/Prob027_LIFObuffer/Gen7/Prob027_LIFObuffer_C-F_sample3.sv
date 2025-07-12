module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write (push), 1: read (pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer (SP): counts number of stored items; 0 = empty, 4 = full
    reg [2:0] SP;

    // Signals to gate operations and reduce toggling
    wire can_push = EN && (RW == 1'b0) && (SP != 3'd4);
    wire can_pop  = EN && (RW == 1'b1) && (SP != 3'd0);

    // Flags derived combinationally from SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // No need to clear stack_mem on reset to reduce reset latency and power
        end else begin
            if (can_push) begin
                // Push data then increment SP
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
            end else if (can_pop) begin
                // Pop: decrement SP then output top data
                SP <= SP - 1;
                dataOut <= stack_mem[SP - 1];
                // Do not clear stack_mem to reduce toggling power
            end
            // No operation if EN low or invalid conditions
        end
    end

endmodule