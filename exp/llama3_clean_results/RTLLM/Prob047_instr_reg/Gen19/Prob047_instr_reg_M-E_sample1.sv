module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

// Parameters for the register bank
parameter REG_SIZE = 8; // Size of each register in bits
parameter NUM_REGS = 2; // Number of registers in the bank

// Type definition for the register bank
typedef reg [REG_SIZE-1:0] reg_type [NUM_REGS-1:0];

// Register bank to store instructions
reg_type reg_bank;

// Finite State Machine (FSM) states
enum logic [1:0] {IDLE, FETCH_REG1, FETCH_REG2} state, next_state;

// Instruction decoder outputs
wire [2:0] opcode;
wire [4:0] reg_addr;
wire [7:0] data_out;

// Clock gating
wire clk_gated = (state == IDLE || state == FETCH_REG1 || state == FETCH_REG2)? clk : 1'b0;

// FSM logic
always @(posedge clk_gated or negedge rst) begin
    if (!rst) begin
        state <= IDLE;
        reg_bank[0] <= 8'd0;
        reg_bank[1] <= 8'd0;
    end else begin
        case (state)
            IDLE: begin
                if (fetch == 2'b01) begin
                    state <= FETCH_REG1;
                    reg_bank[0] <= data;
                end else if (fetch == 2'b10) begin
                    state <= FETCH_REG2;
                    reg_bank[1] <= data;
                end else begin
                    state <= IDLE;
                end
            end
            FETCH_REG1: begin
                state <= IDLE;
            end
            FETCH_REG2: begin
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

// Instruction decoder
assign opcode = reg_bank[0][7:5];
assign reg_addr = reg_bank[0][4:0];
assign data_out = reg_bank[1];

// Output logic
assign ins = opcode;
assign ad1 = reg_addr;
assign ad2 = data_out;

endmodule