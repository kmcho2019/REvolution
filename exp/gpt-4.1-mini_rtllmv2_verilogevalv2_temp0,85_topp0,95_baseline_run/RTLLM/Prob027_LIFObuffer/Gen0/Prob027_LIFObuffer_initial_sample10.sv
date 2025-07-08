module LIFObuffer (
    input       [3:0] dataIn,
    input             RW,
    input             EN,
    input             Rst,
    input             Clk,
    output reg        EMPTY,
    output reg        FULL,
    output reg [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Using 3 bits for range 0-4

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end
        else if (EN) begin
            if (RW == 1'b0) begin // Write (push) operation
                if (SP != 0) begin // Not full
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn; // push dataIn at SP-1 (since SP points to next free position)
                    dataOut <= dataOut; // Hold dataOut value on write
                end
            end
            else begin // RW == 1: Read (pop) operation
                if (SP != 4) begin // Not empty
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0;
                    SP <= SP + 1;
                end
            end

            // Update flags after operation:
            EMPTY <= (SP == 4);
            FULL  <= (SP == 0);
        end
    end

endmodule