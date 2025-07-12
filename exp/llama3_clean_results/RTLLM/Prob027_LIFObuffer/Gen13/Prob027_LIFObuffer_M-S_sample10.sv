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
reg [1:0] SP; // Adjusted stack pointer width

assign EMPTY = (SP == BUFFER_SIZE - 1); 
assign FULL = (SP == 0);

always @(posedge Clk) begin
    if (Rst) begin 
        SP <= BUFFER_SIZE - 1;
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}};
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin 
        if (!RW && SP > 0 && !FULL) begin 
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && SP < BUFFER_SIZE - 1 && !EMPTY) begin 
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= {DATA_WIDTH{1'b0}};
            SP <= SP + 1;
        end
    end
end

endmodule