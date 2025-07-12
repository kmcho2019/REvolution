module instr_reg(
    input clk, // Clock signal for synchronization
    input rst, // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data, // 8-bit data input representing the instruction to be fetched
    output [2:0] ins, // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1, // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2 // The full 8-bit data from the second source
);

reg [7:0] ins_p1; // First 8-bit register to store instruction
reg [7:0] ins_p2; // Second 8-bit register to store instruction

always @(posedge clk or negedge rst) begin
    if (~rst) begin // If reset is low, initialize registers to zero
        ins_p1 <= 8'b0;
        ins_p2 <= 8'b0;
    end else if (fetch == 2'b01) begin // If fetch is 2'b01, update ins_p1 with data
        ins_p1 <= data;
    end else if (fetch == 2'b10) begin // If fetch is 2'b10, update ins_p2 with data
        ins_p2 <= data;
    end
end

assign ins = ins_p1[7:5]; // Derive ins output from high 3 bits of ins_p1
assign ad1 = ins_p1[4:0]; // Derive ad1 output from low 5 bits of ins_p1
assign ad2 = ins_p2; // Derive ad2 output from ins_p2

endmodule