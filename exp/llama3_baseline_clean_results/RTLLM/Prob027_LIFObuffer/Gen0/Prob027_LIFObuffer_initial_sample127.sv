module LIFObuffer(
    input  [3:0] dataIn,
    input         RW,
    input         EN,
    input         Rst,
    input         Clk,
    output        EMPTY,
    output        FULL,
    output [3:0]  dataOut
);

reg [3:0] stack_mem [0:3];
reg [1:0] SP;
reg [3:0] temp_data;

assign EMPTY = (SP == 4) ? 1'b1 : 1'b0;
assign FULL = (SP == 0) ? 1'b1 : 1'b0;

always @(posedge Clk) begin
    if (Rst) begin
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 2'd4;
    end
    else if (EN) begin
        if (~RW && ~FULL) begin
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end
        else if (RW && ~EMPTY) begin
            temp_data <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

assign dataOut = temp_data;

endmodule