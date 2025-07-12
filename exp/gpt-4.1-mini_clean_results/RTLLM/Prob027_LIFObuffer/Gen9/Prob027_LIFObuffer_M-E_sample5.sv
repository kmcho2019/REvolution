module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,       // 0: write(push), 1: read(pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    // Stack memory with 4 entries
    reg [3:0] stack_mem [3:0];

    // Stack pointer: points to top valid element index (0 to 3), 3'd7 means empty (no element)
    reg [2:0] SP;

    // Constants
    localparam EMPTY_SP = 3'd7;  // sentinel for empty stack
    localparam MAX_IDX  = 3'd3;

    // Flags derived from SP
    assign EMPTY = (SP == EMPTY_SP);
    assign FULL  = (SP == MAX_IDX);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= EMPTY_SP;      // empty stack
            dataOut <= 4'd0;
            // Clear memory on reset
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (SP != MAX_IDX) begin
                    SP <= SP + 1'b1;
                    stack_mem[SP + 1'b1] <= dataIn;
                    // dataOut holds previous value
                end
                // else FULL: ignore push
            end else begin
                // Pop operation
                if (SP != EMPTY_SP) begin
                    dataOut <= stack_mem[SP];
                    // Optional: clear popped element for clarity, not mandatory
                    stack_mem[SP] <= 4'd0;
                    SP <= SP - 1'b1;
                end
                // else EMPTY: ignore pop, dataOut holds previous value
            end
        end
        // else EN=0: hold state
    end

endmodule