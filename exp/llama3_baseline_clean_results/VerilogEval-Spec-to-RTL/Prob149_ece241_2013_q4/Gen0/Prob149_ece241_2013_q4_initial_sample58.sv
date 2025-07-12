module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s;
reg fr2_reg, fr1_reg, fr0_reg, dfr_reg;

always @(*) begin
    case (s)
        3'b111: begin
            fr2_reg = 1'b0;
            fr1_reg = 1'b0;
            fr0_reg = 1'b0;
            dfr_reg = 1'b0;
        end
        3'b011: begin
            fr2_reg = 1'b0;
            fr1_reg = 1'b0;
            fr0_reg = 1'b1;
            dfr_reg = (s!= prev_s)? 1'b1 : 1'b0;
        end
        3'b001: begin
            fr2_reg = 1'b0;
            fr1_reg = 1'b1;
            fr0_reg = 1'b1;
            dfr_reg = (s!= prev_s)? 1'b1 : 1'b0;
        end
        default: begin
            fr2_reg = 1'b1;
            fr1_reg = 1'b1;
            fr0_reg = 1'b1;
            dfr_reg = 1'b1;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        fr2 <= fr2_reg;
        fr1 <= fr1_reg;
        fr0 <= fr0_reg;
        dfr <= dfr_reg;
        prev_s <= s;
    end
end

assign fr2 = fr2;
assign fr1 = fr1;
assign fr0 = fr0;
assign dfr = dfr;

endmodule