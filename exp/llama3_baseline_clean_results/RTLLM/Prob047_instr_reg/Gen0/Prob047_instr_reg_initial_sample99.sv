module instr_reg(
    input clk, // Clock signal
    input rst, // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data, // 8-bit data input representing the instruction to be fetched
    output [2:0] ins, // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1, // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2 // The full 8-bit data from the second source
);

reg [7:0] ins_p1; // First 8-bit register to store instruction from the first source
reg [7:0] ins_p2; // Second 8-bit register to store instruction from the second source

always @(posedge clk or negedge rst) begin
    if (~rst) begin // If reset is low, initialize both registers to zero
        ins_p1 <= 8'b0;
        ins_p2 <= 8'b0;
    end else begin
        case (fetch) // Based on the fetch signal, store the instruction in the corresponding register
            2'b01: ins_p1 <= data; // Store the instruction in ins_p1
            2'b10: ins_p2 <= data; // Store the instruction in ins_p2
            default: begin // If fetch is neither 2'b01 nor 2'b10, retain the previous values
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

assign ins = ins_p1[7:5]; // Derive the output 'ins' from the high 3 bits of ins_p1
assign ad1 = ins_p1[4:0]; // Derive the output 'ad1' from the low 5 bits of ins_p1
assign ad2 = ins_p2; // Derive the output 'ad2' from ins_p2

endmodule