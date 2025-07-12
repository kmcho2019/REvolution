module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,       // 0: write (push), 1: read (pop)
    input  wire [3:0] dataIn,
    output reg        EMPTY,
    output reg        FULL,
    output reg [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];  // 4 entries of 4-bit data
    reg [2:0] SP;               // stack pointer: number of items in stack (0 to 4)
    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL  <= 1'b0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) if not full
                if (SP < 4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                    // dataOut unchanged on push
                end
            end else begin
                // Read (pop) if not empty
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                    stack_mem[SP - 1] <= 4'd0;
                end
                // else dataOut unchanged if empty
            end

            // Update flags
            EMPTY <= (SP == 3'd0);
            FULL  <= (SP == 3'd4);
        end
    end

endmodule