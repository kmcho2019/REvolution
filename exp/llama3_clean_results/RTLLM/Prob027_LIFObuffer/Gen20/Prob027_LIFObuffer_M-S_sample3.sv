module LIFObuffer #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [DATA_WIDTH-1:0] dataOut
);

reg [DATA_WIDTH-1:0] stack_mem [0:BUFFER_SIZE-1]; // Stack memory array
reg [2:0] SP; // Stack pointer

assign EMPTY = (SP == BUFFER_SIZE); // Buffer is empty when SP is equal to BUFFER_SIZE
assign FULL = (SP == 0); // Buffer is full when SP is 0

always @(posedge Clk) begin
    if (Rst) begin
        SP <= BUFFER_SIZE;
        stack_mem <= '{default: '0}; // Initialize stack memory to 0
        dataOut <= '0;
    end else if (EN) begin
        if (!RW && !FULL) begin
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && !EMPTY) begin
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= '0;
            SP <= SP + 1;
        end
    end
end

endmodule