module instr_reg (
    input clk,        // Clock signal for synchronization
    input rst,        // Active low reset signal to initialize the register
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched
    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [7:0] ins_p1; // First 8-bit register
reg [7:0] ins_p2; // Second 8-bit register

always @(posedge clk or negedge rst) begin
    if (!rst) begin // Reset condition
        ins_p1 <= 8'd0; // Initialize first register to zero
        ins_p2 <= 8'd0; // Initialize second register to zero
    end else begin
        case (fetch) // Based on the fetch signal
            2'b01: ins_p1 <= data; // Fetch instruction into first register
            2'b10: ins_p2 <= data; // Fetch instruction into second register
            default: ; // Do nothing if neither condition is met
        endcase
    end
end

assign ins = ins_p1[7:5]; // Derive ins output from high 3 bits of ins_p1
assign ad1 = ins_p1[4:0]; // Derive ad1 output from low 5 bits of ins_p1
assign ad2 = ins_p2;     // Derive ad2 output from ins_p2

endmodule