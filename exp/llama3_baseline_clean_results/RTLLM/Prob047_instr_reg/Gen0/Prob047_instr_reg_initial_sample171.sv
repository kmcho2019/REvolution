module instr_reg(
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

reg [7:0] ins_p1;  // Register to store instruction from first source
reg [7:0] ins_p2;  // Register to store instruction from second source

// Update registers on the rising edge of the clock
always @(posedge clk) begin
    if (~rst) begin  // Active low reset
        ins_p1 <= 8'b0;
        ins_p2 <= 8'b0;
    end else begin
        case (fetch)
            2'b01: ins_p1 <= data;  // Fetch from data input into ins_p1
            2'b10: ins_p2 <= data;  // Fetch from data input into ins_p2
            default: begin  // Retain previous values
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

// Derive output signals from stored instructions
assign ins = ins_p1[7:5];  // High 3 bits of ins_p1
assign ad1 = ins_p1[4:0];  // Low 5 bits of ins_p1
assign ad2 = ins_p2;       // Full 8 bits of ins_p2

endmodule