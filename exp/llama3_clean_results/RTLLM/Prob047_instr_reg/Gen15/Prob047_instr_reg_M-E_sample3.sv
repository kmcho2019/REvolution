module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

// Dual-port register file
reg [7:0] reg_file [1:0];

// Write ports
always @(posedge clk or negedge rst) begin
    if (~rst) begin
        reg_file[0] <= 8'd0;
        reg_file[1] <= 8'd0;
    end else if (fetch == 2'b01) begin
        reg_file[0] <= data;
    end else if (fetch == 2'b10) begin
        reg_file[1] <= data;
    end
end

// Read ports
assign ins = reg_file[0][7:5];  // High 3 bits of the instruction
assign ad1 = reg_file[0][4:0];  // Low 5 bits of the instruction
assign ad2 = (fetch == 2'b10)? reg_file[1] : 8'd0;  // Full 8-bit data from the second source

// Clock gating and power gating
wire clk_gated = (fetch!= 2'b00)? clk : 1'b0;
wire power_gated = (fetch!= 2'b00)? 1'b1 : 1'b0;

// Clock gated register file
always @(posedge clk_gated or negedge rst) begin
    if (~rst) begin
        reg_file[0] <= 8'd0;
        reg_file[1] <= 8'd0;
    end else if (fetch == 2'b01) begin
        reg_file[0] <= data;
    end else if (fetch == 2'b10) begin
        reg_file[1] <= data;
    end
end

endmodule