module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s; // previous sensor state
reg fr2_reg, fr1_reg, fr0_reg, dfr_reg; // output registers

always @ (posedge clk) begin
    if (reset) begin // active-high synchronous reset
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
        prev_s <= 3'b000; // reset to "low water level" state
    end else begin
        // determine output based on current sensor state
        if (s == 3'b111) begin // above s[2]
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b0;
            dfr_reg <= 1'b0;
        end else if (s == 3'b011) begin // between s[2] and s[1]
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b0;
            fr0_reg <= 1'b1;
            dfr_reg <= (prev_s < s) ? 1'b1 : 1'b0; // check if water level is rising
        end else if (s == 3'b001) begin // between s[1] and s[0]
            fr2_reg <= 1'b0;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            dfr_reg <= (prev_s < s) ? 1'b1 : 1'b0; // check if water level is rising
        end else begin // below s[0]
            fr2_reg <= 1'b1;
            fr1_reg <= 1'b1;
            fr0_reg <= 1'b1;
            dfr_reg <= 1'b1;
        end
        
        // update previous sensor state
        prev_s <= s;
    end
end

assign fr2 = fr2_reg;
assign fr1 = fr1_reg;
assign fr0 = fr0_reg;
assign dfr = dfr_reg;

endmodule