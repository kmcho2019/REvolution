module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [7:0] ins_p1;  // 8-bit register for first instruction
reg [7:0] ins_p2;  // 8-bit register for second instruction

// Clock enable signals for efficient register updates
wire enable_p1 = (fetch == 2'b01) || (!rst);
wire enable_p2 = (fetch == 2'b10) || (!rst);

// Use of clock enable to reduce power consumption
always @(posedge clk) begin
    if (enable_p1) begin
        if (!rst) begin
            ins_p1 <= 8'd0;
        end else begin
            ins_p1 <= data;
        end
    end
    if (enable_p2) begin
        if (!rst) begin
            ins_p2 <= 8'd0;
        end else begin
            ins_p2 <= data;
        end
    end
end

// Minimal combinational logic for output assignments
assign ins = ins_p1[7:5];  // High 3 bits of the first instruction
assign ad1 = ins_p1[4:0];  // Low 5 bits of the first instruction
assign ad2 = ins_p2;       // Full 8-bit data from the second instruction

endmodule