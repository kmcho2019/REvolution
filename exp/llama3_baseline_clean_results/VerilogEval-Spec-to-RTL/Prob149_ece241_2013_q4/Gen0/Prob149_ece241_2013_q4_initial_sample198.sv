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

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to water level being low for a long time
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        // Determine output flow rates based on current sensor levels
        case ({s[2], s[1], s[0]})
            3'b111: begin // Above s[2]
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b0;
                fr0_reg <= 1'b0;
                dfr_reg <= 1'b0;
            end
            3'b110, 3'b011: begin // Between s[2] and s[1]
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b0;
                fr0_reg <= 1'b1;
                // Check if sensor change indicates previous level was lower
                if ({prev_s[2], prev_s[1], prev_s[0]} < {s[2], s[1], s[0]}) begin
                    dfr_reg <= 1'b1;
                end else begin
                    dfr_reg <= 1'b0;
                end
            end
            3'b100, 3'b010, 3'b001: begin // Between s[1] and s[0]
                fr2_reg <= 1'b0;
                fr1_reg <= 1'b1;
                fr0_reg <= 1'b1;
                // Check if sensor change indicates previous level was lower
                if ({prev_s[2], prev_s[1], prev_s[0]} < {s[2], s[1], s[0]}) begin
                    dfr_reg <= 1'b1;
                end else begin
                    dfr_reg <= 1'b0;
                end
            end
            default: begin // Below s[0]
                fr2_reg <= 1'b1;
                fr1_reg <= 1'b1;
                fr0_reg <= 1'b1;
                // Check if sensor change indicates previous level was lower
                if ({prev_s[2], prev_s[1], prev_s[0]} < {s[2], s[1], s[0]}) begin
                    dfr_reg <= 1'b1;
                end else begin
                    dfr_reg <= 1'b0;
                end
            end
        endcase
        // Update previous sensor level
        prev_s <= {s[2], s[1], s[0]};
    end
end

assign fr2 = fr2_reg;
assign fr1 = fr1_reg;
assign fr0 = fr0_reg;
assign dfr = dfr_reg;

endmodule