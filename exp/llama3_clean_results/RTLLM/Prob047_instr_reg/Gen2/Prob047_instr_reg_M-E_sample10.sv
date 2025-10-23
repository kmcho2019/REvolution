module instr_reg(
    input clk, 
    input rst, 
    input [1:0] fetch, 
    input [7:0] data, 
    output [2:0] ins, 
    output [4:0] ad1, 
    output [7:0] ad2
);

reg [15:0] instr_reg;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        instr_reg <= 16'd0;
    end else begin
        case (fetch)
            2'b01: instr_reg[7:0] <= data;
            2'b10: instr_reg[15:8] <= data;
            default: begin
                instr_reg <= instr_reg;
            end
        endcase
    end
end

assign ins = instr_reg[7:5];
assign ad1 = instr_reg[4:0];
assign ad2 = instr_reg[15:8];

endmodule