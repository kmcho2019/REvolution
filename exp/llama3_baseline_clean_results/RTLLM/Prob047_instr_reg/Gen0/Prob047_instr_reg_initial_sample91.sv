module instr_reg(
    input clk, // Clock signal
    input rst, // Active low reset signal
    input [1:0] fetch, // Control signal to determine the source of the instruction
    input [7:0] data, // 8-bit data input representing the instruction
    output [2:0] ins, // High 3 bits of the instruction
    output [4:0] ad1, // Low 5 bits of the instruction
    output [7:0] ad2 // Full 8-bit data from the second source
);

reg [7:0] ins_p1, ins_p2; // Two 8-bit registers to store instructions

// Assign ins_p1 and ins_p2 to the output ports
assign ins = ins_p1[7:5]; // High 3 bits of ins_p1
assign ad1 = ins_p1[4:0]; // Low 5 bits of ins_p1
assign ad2 = ins_p2; // Full 8-bit data from ins_p2

always @(posedge clk or negedge rst) begin
    if (~rst) begin // If reset is low, initialize both registers to zero
        ins_p1 <= 8'b0;
        ins_p2 <= 8'b0;
    end else begin
        case (fetch)
            2'b01: ins_p1 <= data; // Fetch instruction from data into ins_p1
            2'b10: ins_p2 <= data; // Fetch instruction from data into ins_p2
            default: begin // Retain previous values if fetch is not 2'b01 or 2'b10
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

endmodule