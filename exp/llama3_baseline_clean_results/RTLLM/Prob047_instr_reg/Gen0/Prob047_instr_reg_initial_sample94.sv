module instr_reg(
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

reg [7:0] ins_p1; // First 8-bit register
reg [7:0] ins_p2; // Second 8-bit register

always @(posedge clk or negedge rst) begin
    if (!rst) begin // Active low reset
        ins_p1 <= 8'b0; // Initialize ins_p1 to zero
        ins_p2 <= 8'b0; // Initialize ins_p2 to zero
    end else if (fetch == 2'b01) begin // Fetch from data input into ins_p1
        ins_p1 <= data;
    end else if (fetch == 2'b10) begin // Fetch from data input into ins_p2
        ins_p2 <= data;
    end
end

// Derive output signals from the stored instructions
assign ins = ins_p1[7:5]; // High 3 bits of ins_p1
assign ad1 = ins_p1[4:0]; // Low 5 bits of ins_p1
assign ad2 = ins_p2; // Full 8-bit data from ins_p2

endmodule