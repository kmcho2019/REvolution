module instr_reg (
    input clk, 
    input rst, 
    input [1:0] fetch, 
    input [7:0] data, 
    output [2:0] ins, 
    output [4:0] ad1, 
    output [7:0] ad2
);

reg [15:0] ins_reg;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        ins_reg <= 16'b0;
    end else begin
        case (fetch)
            2'b01: ins_reg[7:0] <= data;
            2'b10: ins_reg[15:8] <= data;
            default: begin
                ins_reg <= ins_reg;
            end
        endcase
    end
end

assign ins = ins_reg[10:8];
assign ad1 = ins_reg[7:3];
assign ad2 = ins_reg[15:8];

endmodule