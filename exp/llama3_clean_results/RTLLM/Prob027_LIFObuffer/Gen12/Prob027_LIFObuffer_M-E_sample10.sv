module LIFObuffer #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4,
    parameter REG_FILE_DEPTH = 2
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

// Register file to store top elements of the stack
reg [DATA_WIDTH-1:0] reg_file [0:REG_FILE_DEPTH-1];

// RAM block to store deeper elements of the stack
reg [DATA_WIDTH-1:0] ram_block [0:BUFFER_SIZE-REG_FILE_DEPTH-1];

// Pointers for stack and buffer
reg [BUFFER_SIZE-1:0] SP;
reg [BUFFER_SIZE-REG_FILE_DEPTH-1:0] BP;

// Control signals
reg push_reg, pop_reg, push_ram, pop_ram;

// Combinational logic for control signals
always @(*) begin
    push_reg = EN && !RW && SP < REG_FILE_DEPTH;
    pop_reg = EN && RW && SP > 0;
    push_ram = EN && !RW && SP >= REG_FILE_DEPTH && BP < BUFFER_SIZE-REG_FILE_DEPTH;
    pop_ram = EN && RW && SP == 0 && BP > 0;
end

// Sequential logic for register file, RAM block, and pointers
always @(posedge Clk) begin
    if (Rst) begin
        // Initialize register file, RAM block, and pointers
        for (int i = 0; i < REG_FILE_DEPTH; i++) begin
            reg_file[i] <= {DATA_WIDTH{1'b0}};
        end
        for (int i = 0; i < BUFFER_SIZE-REG_FILE_DEPTH; i++) begin
            ram_block[i] <= {DATA_WIDTH{1'b0}};
        end
        SP <= 0;
        BP <= 0;
    end else begin
        // Update register file and pointers based on control signals
        if (push_reg) begin
            reg_file[SP] <= dataIn;
            SP <= SP + 1;
        end
        if (pop_reg) begin
            dataOut <= reg_file[SP-1];
            SP <= SP - 1;
        end
        if (push_ram) begin
            ram_block[BP] <= reg_file[REG_FILE_DEPTH-1];
            reg_file[REG_FILE_DEPTH-1] <= dataIn;
            BP <= BP + 1;
        end
        if (pop_ram) begin
            reg_file[0] <= ram_block[BP-1];
            BP <= BP - 1;
        end
    end
end

// Update EMPTY and FULL flags
assign EMPTY = (SP == 0 && BP == 0);
assign FULL = (SP == REG_FILE_DEPTH && BP == BUFFER_SIZE-REG_FILE_DEPTH);

endmodule