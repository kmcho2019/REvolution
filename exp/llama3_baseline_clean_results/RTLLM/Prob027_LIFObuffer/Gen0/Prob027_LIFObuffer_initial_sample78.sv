module LIFObuffer(
    input   wire [3:0] dataIn,
    input   wire       RW,
    input   wire       EN,
    input   wire       Rst,
    input   wire       Clk,
    output  wire       EMPTY,
    output  wire       FULL,
    output  wire [3:0] dataOut
);

reg [3:0] stack_mem [3:0];
reg [1:0] SP;

assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

always @(posedge Clk) begin
    if (Rst) begin
        stack_mem <= '{default: 4'b0};
        SP <= 4;
    end else if (EN) begin
        if (~RW && (SP != 0)) begin  // push operation
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && (SP != 4)) begin  // pop operation
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

endmodule