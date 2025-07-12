module instr_reg(
    input clk, // Clock signal
    input rst_n, // Active low reset signal
    input [1:0] fetch, // Control signal
    input [7:0] data, // 8-bit data input
    output [2:0] ins, // High 3 bits of the instruction
    output [4:0] ad1, // Low 5 bits of the instruction
    output [7:0] ad2 // Full 8-bit data from the second source
);

reg [7:0] ins_p1; // 8-bit register to store instruction from first source
reg [7:0] ins_p2; // 8-bit register to store instruction from second source

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // If reset signal is low, initialize both registers to zero
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
    end else begin
        case (fetch)
            2'b01: // If fetch is 2'b01, fetch instruction from data input into ins_p1
                ins_p1 <= data;
            2'b10: // If fetch is 2'b10, fetch instruction from data input into ins_p2
                ins_p2 <= data;
            default: // If neither condition is met, retain previous values
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
        endcase
    end
end

// Derive outputs from stored instructions
assign ins = ins_p1[7:5]; // High 3 bits of the instruction
assign ad1 = ins_p1[4:0]; // Low 5 bits of the instruction
assign ad2 = ins_p2; // Full 8-bit data from the second source

endmodule