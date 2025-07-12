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

// Combinational logic for next stack pointer value
wire [BUFFER_SIZE-1:0] next_SP;
assign next_SP = (Rst) ? BUFFER_SIZE :
                 (EN && !RW && SP > 0) ? SP - 1 :
                 (EN && RW && SP < BUFFER_SIZE) ? SP + 1 :
                 SP;

// Sequential logic for stack pointer
always @(posedge Clk) begin
    if (Rst) begin
        SP <= BUFFER_SIZE; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
    end else if (EN) begin
        SP <= next_SP; // Update stack pointer
    end
end

// Sequential logic for stack memory
always @(posedge Clk) begin
    if (Rst) begin
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
    end else if (EN) begin
        if (!RW && SP > 0) begin // Push operation
            stack_mem[SP-1] <= dataIn; // Push data onto stack
        end else if (RW && SP < BUFFER_SIZE) begin // Pop operation
            stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
        end
    end
end

// Sequential logic for dataOut
always @(posedge Clk) begin
    if (Rst) begin
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN && RW && SP < BUFFER_SIZE) begin // Pop operation
        dataOut <= stack_mem[SP]; // Pop data from stack
    end
end

// Continuous assignments for EMPTY and FULL flags
assign EMPTY = (SP == BUFFER_SIZE); // Buffer is empty when SP is equal to BUFFER_SIZE
assign FULL = (SP == 0); // Buffer is full when SP is 0

endmodule