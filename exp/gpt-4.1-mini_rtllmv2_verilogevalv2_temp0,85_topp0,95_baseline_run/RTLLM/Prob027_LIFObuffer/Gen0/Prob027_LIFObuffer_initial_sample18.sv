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
    reg [2:0] SP; // stack pointer from 0 to 4, 3 bits enough

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset: clear stack, set SP to 4, clear outputs and flags
            SP <= 3'd4;
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            // Normal operation
            if (RW == 1'b0) begin
                // Write operation (push)
                if (SP != 0) begin
                    SP <= SP - 1'b1;
                    stack_mem[SP - 1] <= dataIn;
                    dataOut <= dataOut; // hold previous dataOut
                end
                // else full, do nothing
            end else begin
                // Read operation (pop)
                if (SP != 4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0;
                    SP <= SP + 1'b1;
                end else begin
                    dataOut <= dataOut; // hold previous dataOut if empty
                end
            end

            // Update flags after SP change
            EMPTY <= (SP == 3'd4);
            FULL <= (SP == 3'd0);
        end
    end
endmodule