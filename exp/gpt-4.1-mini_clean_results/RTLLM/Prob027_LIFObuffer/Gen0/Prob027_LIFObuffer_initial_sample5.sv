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
    reg [2:0] SP;               // stack pointer, range [0..4]

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset: clear stack, set SP to 4, clear outputs and flags
            SP <= 3'd4;
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL  <= 1'b0;
            for (i=0; i<4; i=i+1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) if not full
                if (SP > 0) begin
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                    dataOut <= dataOut; // unchanged
                end
            end else begin
                // Read (pop) if not empty
                if (SP < 4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0;
                    SP <= SP + 1;
                end else begin
                    dataOut <= dataOut; // unchanged if empty
                end
            end

            // Update flags after operation
            EMPTY <= (SP == 3'd4);
            FULL  <= (SP == 3'd0);
        end
    end

endmodule