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

reg [3:0] stack_mem [0:3]; // stack memory array
reg [1:0] SP; // stack pointer

always @(posedge Clk) begin
    if (Rst) begin // reset operation
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4; // reset stack pointer to 4 (indicating an empty buffer)
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin // enable operation
        if (!RW && (SP != 2'd0)) begin // push operation
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && (SP != 2'd4)) begin // pop operation
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1;
        end
        // update flags
        if (SP == 2'd4) begin
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else if (SP == 2'd0) begin
            EMPTY <= 1'b0;
            FULL <= 1'b1;
        end else begin
            EMPTY <= 1'b0;
            FULL <= 1'b0;
        end
    end
end

endmodule