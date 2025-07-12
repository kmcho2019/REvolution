module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

reg [2:0] ins_reg;
reg [4:0] ad1_reg;
reg [7:0] ad2_reg;

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        ins_reg <= 3'd0;
        ad1_reg <= 5'd0;
        ad2_reg <= 8'd0;
    end else begin
        case (fetch)
            2'b01: begin
                ins_reg <= data[7:5];
                ad1_reg <= data[4:0];
            end
            2'b10: begin
                ad2_reg <= data;
            end
            default: begin
                // No change to the registers on other fetch values
            end
        endcase
    end
end

assign ins = ins_reg;
assign ad1 = ad1_reg;
assign ad2 = ad2_reg;

endmodule