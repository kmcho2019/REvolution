module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= 4'd0;
    end else if (slowena) begin
        case (q_reg)
            4'd0: q_reg <= 4'd1;
            4'd1: q_reg <= 4'd2;
            4'd2: q_reg <= 4'd3;
            4'd3: q_reg <= 4'd4;
            4'd4: q_reg <= 4'd5;
            4'd5: q_reg <= 4'd6;
            4'd6: q_reg <= 4'd7;
            4'd7: q_reg <= 4'd8;
            4'd8: q_reg <= 4'd9;
            4'd9: q_reg <= 4'd0;
            default: q_reg <= 4'd0;
        endcase
    end
end

assign q = q_reg;

endmodule