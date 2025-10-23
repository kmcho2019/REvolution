module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst_n,       // Active high reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [7:0] ins_reg;  // Single 8-bit register to store instructions
reg [7:0] prev_ins; // Register to store the previous instruction for ad2

always @(posedge clk) begin
    if (rst_n) begin
        if (fetch == 2'b01 || fetch == 2'b10) begin
            ins_reg <= data;
            prev_ins <= ins_reg;
        end
    end else begin
        ins_reg <= 8'd0;
        prev_ins <= 8'd0;
    end
end

assign ins = ins_reg[7:5];  // High 3 bits of the instruction
assign ad1 = ins_reg[4:0];  // Low 5 bits of the instruction
assign ad2 = (fetch == 2'b10)? data : prev_ins;  // Full 8-bit data from the second source

endmodule