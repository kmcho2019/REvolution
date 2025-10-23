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

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to water level being low for a long time
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        // Determine nominal flow rate based on current sensor state
        case (s)
            3'b111: begin // Above highest sensor
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            3'b110: begin // Between highest and middle sensors
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (prev_s < s) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            3'b100: begin // Between middle and lowest sensors
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (prev_s < s) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            default: begin // Below lowest sensor
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (prev_s < s) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
        endcase

        // Update previous sensor state
        prev_s <= s;
    end
end

endmodule