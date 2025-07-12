module LIFObuffer(
    input logic Clk,
    input logic Rst,
    input logic EN,
    input logic RW,
    input logic [3:0] dataIn,
    output logic EMPTY,
    output logic FULL,
    output logic [3:0] dataOut
);

logic [3:0] stack_mem [3:0]; // 4x4 stack memory array
logic [1:0] SP; // 2-bit stack pointer

always_ff @(posedge Clk) begin
    if (Rst) begin // reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 2'd4; // set stack pointer to indicate an empty buffer
        dataOut <= 4'b0;
    end else if (EN) begin // enable buffer operations
        if (~RW && (SP!= 2'd0)) begin // push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && (SP!= 2'd4)) begin // pop data from the stack
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

assign EMPTY = (SP == 2'd4); // flag for empty buffer
assign FULL = (SP == 2'd0); // flag for full buffer

endmodule