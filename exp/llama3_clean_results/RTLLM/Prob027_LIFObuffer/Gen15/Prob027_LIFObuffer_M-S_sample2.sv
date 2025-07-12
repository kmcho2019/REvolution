module LIFObuffer (
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [0:3]; // Stack memory array
reg [1:0] SP; // Stack pointer

assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

always @(posedge Clk) begin
    if (Rst) begin
        SP <= 4; // Initialize stack pointer to 4 (empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // Initialize stack memory to 0
        end
        dataOut <= 4'b0;
    end else if (EN) begin
        if (!RW && SP > 0 && !FULL) begin // Push operation
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && SP < 4 && !EMPTY) begin // Pop operation
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

endmodule