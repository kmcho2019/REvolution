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

    // Stack Pointer (SP): 0 to 4
    // SP points to the next free slot
    // SP == 0 means empty
    // SP == 4 means full
    reg [2:0] SP;

    integer i;

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // Initialize stack_mem synchronously with Rst asserted
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) operation if not full
                if (SP != 3'd4) begin
                    stack_mem[SP[1:0]] <= dataIn;
                    SP <= SP + 1'b1;
                    // dataOut remains unchanged during push
                end
                // else buffer full, no operation
            end else begin
                // Read (pop) operation if not empty
                if (SP != 3'd0) begin
                    SP <= SP - 1'b1;
                    dataOut <= stack_mem[(SP - 1'b1)[1:0]];
                    // do not clear stack_mem to save switching
                end
                // else buffer empty, no operation, dataOut unchanged
            end
        end
        // else EN=0, no operation, keep previous values
    end

endmodule