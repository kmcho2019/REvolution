module LIFObuffer(
    input  logic        Clk,
    input  logic        Rst,
    input  logic        EN,
    input  logic        RW,
    input  logic [3:0]  dataIn,
    output logic [3:0]  dataOut,
    output logic        EMPTY,
    output logic        FULL
);

logic [3:0] stack_mem [0:3];
logic [1:0] SP;

always_ff @(posedge Clk) begin
    if (Rst) begin
        SP <= 2'd4;
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
    end else if (EN) begin
        if (~RW && (SP != 2'd0)) begin // write operation
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && (SP != 2'd4)) begin // read operation
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1;
        end
    end
end

always_comb begin
    EMPTY = (SP == 2'd4);
    FULL = (SP == 2'd0);
    if (RW && ~EMPTY)
        dataOut = stack_mem[SP];
    else
        dataOut = 4'd0;
end

endmodule