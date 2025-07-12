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
reg [1:0] next_SP;

always @(*) begin
    next_SP = SP;
    if (RW && SP < 2'd3 && EN) begin // Pop operation
        next_SP = SP + 1;
    end else if (!RW && SP > 2'd0 && EN) begin // Push operation
        next_SP = SP - 1;
    end
end

always @(posedge Clk) begin
    if (Rst) begin
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd3;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        SP <= next_SP;
        if (!RW && SP > 2'd0) begin // Push operation
            stack_mem[SP - 1] <= dataIn;
        end else if (RW && SP < 2'd3) begin // Pop operation
            dataOut <= stack_mem[SP];
        end
        EMPTY <= (SP == 2'd3);
        FULL <= (SP == 2'd0);
    end
end

assign EMPTY = (SP == 2'd3);
assign FULL = (SP == 2'd0);

endmodule