module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst_n,       // Active high reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

// Using two separate 8-bit registers for clarity and simplicity
reg [7:0] ins_p1;
reg [7:0] ins_p2;

// Clock enable signals for ins_p1 and ins_p2
wire ce_p1;
wire ce_p2;

assign ce_p1 = (fetch == 2'b01);
assign ce_p2 = (fetch == 2'b10);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
    end else begin
        if (ce_p1) begin
            ins_p1 <= data;
        end
        if (ce_p2) begin
            ins_p2 <= data;
        end
    end
end

// Assigning outputs directly from the registers for minimal combinational logic
assign ins = ins_p1[7:5];
assign ad1 = ins_p1[4:0];
assign ad2 = ins_p2;

endmodule