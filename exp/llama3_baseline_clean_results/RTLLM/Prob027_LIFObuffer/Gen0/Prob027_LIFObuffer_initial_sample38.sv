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

reg [3:0] stack_mem [3:0];
reg [1:0] SP;

always @ (posedge Clk) begin
    if (Rst) begin
        SP <= 4;
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
    end else if (EN) begin
        if (RW == 0 && SP > 0) begin // write operation
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end else if (RW == 1 && SP < 4) begin // read operation
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

always @ (*) begin
    if (SP == 4) begin
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (SP == 0) begin
        EMPTY <= 1'b0;
        FULL <= 1'b1;
    end else begin
        EMPTY <= 1'b0;
        FULL <= 1'b0;
    end
end

endmodule