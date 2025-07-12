module instr_reg(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data, // 8-bit data input representing the instruction
    output [2:0] ins, // High 3 bits of the instruction
    output [4:0] ad1, // Low 5 bits of the instruction
    output [7:0] ad2 // The full 8-bit data from the second source
);

reg [7:0] ins_p1; // First 8-bit register to store instructions
reg [7:0] ins_p2; // Second 8-bit register to store instructions

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Active-low reset
        ins_p1 <= 8'd0; // Initialize first register to zero
        ins_p2 <= 8'd0; // Initialize second register to zero
    end else begin
        case (fetch) // Determine which register to update
            2'b01: ins_p1 <= data; // Update first register
            2'b10: ins_p2 <= data; // Update second register
            default: ; // Retain previous values
        endcase
    end
end

assign ins = ins_p1[7:5]; // High 3 bits of the instruction
assign ad1 = ins_p1[4:0]; // Low 5 bits of the instruction
assign ad2 = ins_p2; // Full 8-bit data from the second source

endmodule