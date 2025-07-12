module instr_reg(
    input clk, 
    input rst, 
    input [1:0] fetch, 
    input [7:0] data, 
    output [2:0] ins, 
    output [4:0] ad1, 
    output [7:0] ad2
);

// Using two separate registers to potentially allow for easier clock gating in the future
reg [7:0] ins_p1;
reg [7:0] ins_p2;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
    end else begin
        case (fetch)
            2'b01: ins_p1 <= data;
            2'b10: ins_p2 <= data;
            default: begin
                // No change, maintaining current values
            end
        endcase
    end
end

// Deriving output signals directly from the registers
assign ins = ins_p1[7:5];
assign ad1 = {3'b0, ins_p1[4:0]}; // Ensuring ad1 is always 5 bits, padding with zeros
assign ad2 = ins_p2;

endmodule