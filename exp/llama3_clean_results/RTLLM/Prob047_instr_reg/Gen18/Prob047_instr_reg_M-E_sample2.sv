module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [7:0] instr_buf1; // First 8-bit buffer for storing the instruction
reg [7:0] instr_buf2; // Second 8-bit buffer for temporary holding of decoded information
reg clk_enable;      // Clock enable signal for clock gating

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        instr_buf1 <= 8'd0; // Reset the first buffer when rst is low
        instr_buf2 <= 8'd0; // Reset the second buffer when rst is low
        clk_enable <= 1'b0; // Reset the clock enable signal
    end else if (fetch != 2'b00) begin
        // Update the first buffer with the new instruction
        instr_buf1 <= data;
        
        // Determine if the clock should be enabled for the second buffer
        if (fetch == 2'b10) begin
            clk_enable <= 1'b1;
        end else begin
            clk_enable <= 1'b0;
        end
    end
end

// Instruction decoder (combinational logic)
always @(*) begin
    case (instr_buf1[7:5])
        3'b000: begin // Example opcode handling
            instr_buf2 = {3'b000, instr_buf1[4:0]};
        end
        3'b001: begin // Example opcode handling
            instr_buf2 = {3'b001, instr_buf1[4:0]};
        end
        default: begin
            instr_buf2 = 8'd0; // Default handling
        end
    endcase
end

// Output logic
assign ins = instr_buf1[7:5]; // High 3 bits of the instruction
assign ad1 = instr_buf1[4:0]; // Low 5 bits of the instruction
assign ad2 = (fetch == 2'b10) ? instr_buf2 : 8'd0; // Output the decoded information or zero

// Clock gating
always @(posedge clk) begin
    if (clk_enable) begin
        // Perform operations that require the clock when enabled
    end
end

endmodule