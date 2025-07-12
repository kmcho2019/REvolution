module instr_reg(
    input clk, // Clock signal
    input rst_n, // Active low reset signal
    input [1:0] fetch, // Control signal for instruction source
    input [7:0] data, // 8-bit data input
    output [2:0] ins, // High 3 bits of the instruction
    output [4:0] ad1, // Low 5 bits of the instruction
    output [7:0] ad2 // Full 8-bit data from the second source
);

reg [7:0] ins_p1; // First 8-bit register
reg [7:0] ins_p2; // Second 8-bit register

// Update registers on rising edge of clock
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // If reset is low, initialize registers
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
    end else begin
        case (fetch)
            2'b01: ins_p1 <= data; // Fetch from data input into ins_p1
            2'b10: ins_p2 <= data; // Fetch from data input into ins_p2
            default: ; // Retain previous values if fetch is neither 2'b01 nor 2'b10
        endcase
    end
end

// Derive output signals from stored instructions
assign ins = ins_p1[7:5]; // High 3 bits of ins_p1
assign ad1 = ins_p1[4:0]; // Low 5 bits of ins_p1
assign ad2 = ins_p2; // Full 8-bit data from ins_p2

endmodule