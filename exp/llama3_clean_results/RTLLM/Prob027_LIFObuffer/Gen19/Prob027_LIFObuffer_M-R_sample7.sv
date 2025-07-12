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

reg [DATA_WIDTH-1:0] stack_mem [0:BUFFER_SIZE-1]; // Stack memory
reg [BUFFER_SIZE-1:0] SP; // Stack pointer

// Clock gating for stack memory and stack pointer
wire clk_gated;
assign clk_gated = (EN || Rst) ? Clk : 1'b0;

// Sequential logic for stack pointer and dataOut
always @(posedge clk_gated) begin
    if (Rst) begin // Active high reset
        SP <= BUFFER_SIZE; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
        stack_mem <= '{default: {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        dataOut <= {DATA_WIDTH{1'b0}};
        EMPTY <= 1'b1; // Initialize EMPTY flag
        FULL <= 1'b0; // Initialize FULL flag
    end else if (EN) begin // Enable signal is high
        if (!RW && SP > 0) begin // Push operation
            stack_mem[SP-1] <= dataIn; // Push data onto stack
            SP <= SP - 1; // Update stack pointer
            EMPTY <= 1'b0; // Update EMPTY flag
            FULL <= (SP == 1) ? 1'b1 : 1'b0; // Update FULL flag
        end else if (RW && SP < BUFFER_SIZE) begin // Pop operation
            dataOut <= stack_mem[SP]; // Pop data from stack
            stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            SP <= SP + 1; // Update stack pointer
            FULL <= 1'b0; // Update FULL flag
            EMPTY <= (SP == BUFFER_SIZE) ? 1'b1 : 1'b0; // Update EMPTY flag
        end
    end
end

endmodule