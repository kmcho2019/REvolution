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
reg [BUFFER_SIZE-1:0] SP; // Stack pointer

// Reset logic
always @(posedge Rst or posedge Clk) begin
    if (Rst) begin
        SP <= BUFFER_SIZE;
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}};
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin
        if (!RW && SP > 0) begin // Push operation
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && SP < BUFFER_SIZE) begin // Pop operation
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= {DATA_WIDTH{1'b0}};
            SP <= SP + 1;
        end
    end
end

// Flag logic
assign EMPTY = (SP == BUFFER_SIZE);
assign FULL = (SP == 0);

endmodule