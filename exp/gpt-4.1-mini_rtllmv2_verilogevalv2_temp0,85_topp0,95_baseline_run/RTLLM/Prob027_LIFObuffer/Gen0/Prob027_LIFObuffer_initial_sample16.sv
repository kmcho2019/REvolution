module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output reg        EMPTY,
    output reg        FULL,
    output reg [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // stack pointer, range 0..4, needs 3 bits

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset: clear stack and set SP to 4 (empty)
            SP <= 3'd4;
            dataOut <= 4'b0000;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'b0000;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) operation
                if (SP != 0) begin
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                    dataOut <= dataOut; // no change to dataOut on push
                end
                // else full, ignore push
            end else begin
                // Read (pop) operation
                if (SP != 4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0000;
                    SP <= SP + 1;
                end
                // else empty, ignore pop
            end

            // Update flags after operation
            EMPTY <= (SP == 4);
            FULL  <= (SP == 0);
        end
    end

endmodule