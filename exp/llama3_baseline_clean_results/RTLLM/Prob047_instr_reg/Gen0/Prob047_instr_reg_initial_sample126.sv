module instr_reg(
    input clk,  // Clock signal for synchronization
    input rst_n,  // Active low reset signal to initialize the register
    input [1:0] fetch,  // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched
    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2  // The full 8-bit data from the second source
);

reg [7:0] ins_p1;  // 8-bit register to store instruction from source 1
reg [7:0] ins_p2;  // 8-bit register to store instruction from source 2

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // If reset signal is low, initialize both registers to zero
        ins_p1 <= 8'b0;
        ins_p2 <= 8'b0;
    end else begin
        case (fetch)  // Update the corresponding register based on the fetch signal
            2'b01: ins_p1 <= data;
            2'b10: ins_p2 <= data;
            default: begin
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

assign ins = ins_p1[7:5];  // Derive ins output from the high 3 bits of ins_p1
assign ad1 = ins_p1[4:0];  // Derive ad1 output from the low 5 bits of ins_p1
assign ad2 = ins_p2;  // Derive ad2 output from the full 8-bit ins_p2

endmodule