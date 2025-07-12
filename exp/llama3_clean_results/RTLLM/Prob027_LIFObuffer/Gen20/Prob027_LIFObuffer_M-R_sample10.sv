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

// Combinational logic for EMPTY and FULL flags
wire empty_flag, full_flag;
assign empty_flag = (SP == BUFFER_SIZE);
assign full_flag = (SP == 0);

// Sequential logic for stack pointer
always @(posedge Clk) begin
    if (Rst) begin
        SP <= BUFFER_SIZE;
    end else if (EN) begin
        SP <= next_SP;
    end
end

// Sequential logic for stack memory
always @(posedge Clk) begin
    if (Rst) begin
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}};
        end
    end else if (EN && !RW && SP > 0) begin
        stack_mem[SP-1] <= dataIn;
    end else if (EN && RW && SP < BUFFER_SIZE) begin
        stack_mem[SP] <= {DATA_WIDTH{1'b0}};
    end
end

// Combinational logic for dataOut
assign dataOut = (EN && RW && SP < BUFFER_SIZE) ? stack_mem[SP] : {DATA_WIDTH{1'b0}};

// Sequential logic for EMPTY and FULL flags
always @(posedge Clk) begin
    if (Rst) begin
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        EMPTY <= empty_flag;
        FULL <= full_flag;
    end
end

endmodule