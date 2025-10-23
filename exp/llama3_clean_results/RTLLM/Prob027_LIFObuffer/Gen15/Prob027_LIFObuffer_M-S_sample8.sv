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

reg [DATA_WIDTH-1:0] stack_mem [0:BUFFER_SIZE-1];
reg [2:0] SP;

always @(posedge Clk) begin
    if (Rst) begin
        SP <= BUFFER_SIZE;
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}};
        end
    end else if (EN) begin
        if (!RW && SP > 0) begin // Push
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && SP < BUFFER_SIZE) begin // Pop
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= {DATA_WIDTH{1'b0}};
            SP <= SP + 1;
        end
    end
end

assign EMPTY = (SP == BUFFER_SIZE);
assign FULL = (SP == 0);

endmodule