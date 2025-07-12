module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [7:0] instr_reg;  // Single 8-bit register to store instructions
reg [1:0] current_source;  // Register to keep track of the current source

always @ (posedge clk or negedge rst) begin
    if (~rst) begin
        instr_reg <= 8'd0;  // Reset the register when rst is low
        current_source <= 2'd0;  // Reset the current source
    end else begin
        case (fetch)
            2'b01: begin
                instr_reg <= data;  // Update the register with the new instruction
                current_source <= 2'd1;  // Update the current source
            end
            2'b10: begin
                instr_reg <= data;  // Update the register with the new instruction
                current_source <= 2'd2;  // Update the current source
            end
            default: begin
                // No update
            end
        endcase
    end
end

// Output logic using the current source
always @ (*) begin
    case (current_source)
        2'd1: begin
            ins = instr_reg[7:5];  // High 3 bits of the instruction
            ad1 = instr_reg[4:0];  // Low 5 bits of the instruction
            ad2 = 8'd0;  // Full 8-bit data from the second source
        end
        2'd2: begin
            ins = instr_reg[7:5];  // High 3 bits of the instruction
            ad1 = instr_reg[4:0];  // Low 5 bits of the instruction
            ad2 = instr_reg;  // Full 8-bit data from the second source
        end
        default: begin
            ins = 3'd0;  // High 3 bits of the instruction
            ad1 = 5'd0;  // Low 5 bits of the instruction
            ad2 = 8'd0;  // Full 8-bit data from the second source
        end
    endcase
end

endmodule