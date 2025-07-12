module instr_reg(
    input clk, 
    input rst, 
    input [1:0] fetch, 
    input [7:0] data, 
    output [2:0] ins, 
    output [4:0] ad1, 
    output [7:0] ad2
);

reg [7:0] ins_p1;
reg [7:0] ins_p2;

// Clock gating for power reduction
reg clk_gated_p1;
reg clk_gated_p2;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
        clk_gated_p1 <= 1'b0;
        clk_gated_p2 <= 1'b0;
    end else begin
        case (fetch)
            2'b01: begin
                ins_p1 <= data;
                clk_gated_p1 <= 1'b1;
                clk_gated_p2 <= 1'b0;
            end
            2'b10: begin
                ins_p2 <= data;
                clk_gated_p1 <= 1'b0;
                clk_gated_p2 <= 1'b1;
            end
            default: begin
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
                clk_gated_p1 <= 1'b0;
                clk_gated_p2 <= 1'b0;
            end
        endcase
    end
end

// Derive outputs
assign ins = ins_p1[7:5];
assign ad1 = ins_p1[4:0];
assign ad2 = ins_p2;

endmodule