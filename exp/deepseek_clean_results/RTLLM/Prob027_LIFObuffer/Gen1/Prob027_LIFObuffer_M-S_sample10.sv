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

    reg [3:0] stack_mem [0:3];
    reg [2:0] SP;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP-1] <= dataIn;
                SP <= SP - 1;
                EMPTY <= 1'b0;
                FULL <= (SP == 1);
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP];
                SP <= SP + 1;
                FULL <= 1'b0;
                EMPTY <= (SP == 3);
            end
        end
    end

endmodule