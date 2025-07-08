module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // 3 bits to count from 0 to 4

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset: clear stack, set SP to 4 (empty)
            SP <= 3'd4;
            dataOut <= 4'b0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'b0;
            end
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write operation (push)
                if (SP != 0) begin
                    SP <= SP - 1'b1;
                    stack_mem[SP - 1] <= dataIn;
                    dataOut <= 4'b0;
                end
                // else full, no push
            end else begin
                // Read operation (pop)
                if (SP != 4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0;
                    SP <= SP + 1'b1;
                end else begin
                    dataOut <= 4'b0;
                end
            end
            // Update flags after operation
            EMPTY <= (SP == 4);
            FULL <= (SP == 0);
        end
    end

endmodule