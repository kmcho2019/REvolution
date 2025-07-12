module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [0:3];
reg [1:0] SP;

always @(posedge Clk) begin
    if (Rst) begin
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd3;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        if (!RW && SP > 2'd0) begin // Push
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && SP < 2'd3) begin // Pop
            dataOut <= stack_mem[SP];
            SP <= SP + 1;
        end
        EMPTY <= (SP == 2'd3);
        FULL <= (SP == 2'd0);
    end
end

endmodule