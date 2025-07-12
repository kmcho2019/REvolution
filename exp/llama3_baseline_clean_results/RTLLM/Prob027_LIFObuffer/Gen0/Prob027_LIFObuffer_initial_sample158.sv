module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output EMPTY,
    output FULL,
    output [3:0] dataOut
);

reg [3:0] stack_mem [0:3]; // Stack memory array
reg [1:0] SP; // Stack pointer
reg EMPTY, FULL;

always @(posedge Clk) begin
    if (Rst) begin // Reset
        SP <= 4;
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
    end else if (EN) begin // Enable signal is high
        if (~RW && (SP > 0)) begin // Write operation and buffer is not full
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && (SP < 4)) begin // Read operation and buffer is not empty
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

assign EMPTY = (SP == 4);
assign FULL = (SP == 0);
assign dataOut = (SP < 4) ? stack_mem[SP] : 4'b0;

endmodule