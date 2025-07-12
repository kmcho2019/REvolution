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

// Initialize stack memory and stack pointer on reset
always @(posedge Clk) begin
    if (Rst) begin
        SP <= BUFFER_SIZE;
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}};
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end
end

// Update stack pointer based on push/pop operations
always @(posedge Clk) begin
    if (!Rst && EN) begin
        if (!RW && SP > 0 && !FULL) begin
            SP <= SP - 1;
        end else if (RW && SP < BUFFER_SIZE && !EMPTY) begin
            SP <= SP + 1;
        end
    end
end

// Handle push/pop data operations
always @(posedge Clk) begin
    if (!Rst && EN) begin
        if (!RW && SP > 0 && !FULL) begin
            stack_mem[SP-1] <= dataIn;
        end else if (RW && SP < BUFFER_SIZE && !EMPTY) begin
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= {DATA_WIDTH{1'b0}};
        end
    end
end

// Combinational logic for EMPTY and FULL flags
assign EMPTY = (SP == BUFFER_SIZE);
assign FULL = (SP == 0);

endmodule