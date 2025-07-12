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

    // Stack Pointer: values 0 to 4 inclusive;
    // SP == 4 means empty; SP == 0 means full
    reg [2:0] SP;

    integer i;

    // Derived signals for gating operations
    wire can_push  = EN && (RW == 1'b0) && (SP != 3'd0);
    wire can_pop   = EN && (RW == 1'b1) && (SP != 3'd4);

    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            // Only update on valid operations to reduce switching
            if (can_push) begin
                // Push operation: decrement SP, then write dataIn
                SP <= SP - 1;
                // SP - 1 is next top index
                stack_mem[SP - 1] <= dataIn;
            end else if (can_pop) begin
                // Pop operation: read current top data, then increment SP
                dataOut <= stack_mem[SP];
                SP <= SP + 1;
                // Do not clear memory to reduce switching
            end
            // If no operation or EN low: hold state (no changes)
        end
    end

endmodule