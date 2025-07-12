module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [7:0] ins_p1;  // First instruction register
reg [7:0] ins_p2;  // Second instruction register

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        ins_p1 <= 8'd0;  // Reset ins_p1 to zero
        ins_p2 <= 8'd0;  // Reset ins_p2 to zero
    end else if (fetch == 2'b01) begin
        ins_p1 <= data;  // Update ins_p1 with the new instruction
    end else if (fetch == 2'b10) begin
        ins_p2 <= data;  // Update ins_p2 with the new instruction
    end
end

// Output logic using direct assignments for clarity and optimization
assign ins = (fetch == 2'b01)? ins_p1[7:5] : ins_p2[7:5];  // High 3 bits of the instruction
assign ad1 = (fetch == 2'b01)? ins_p1[4:0] : ins_p2[4:0];  // Low 5 bits of the instruction
assign ad2 = (fetch == 2'b10)? ins_p2 : (fetch == 2'b01)? ins_p1 : 8'd0;  // Full 8-bit data from the second source

endmodule