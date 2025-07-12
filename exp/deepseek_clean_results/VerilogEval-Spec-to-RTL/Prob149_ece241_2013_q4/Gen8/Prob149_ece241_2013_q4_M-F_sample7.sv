module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;
    reg rising;

    // Sequential logic for state storage
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
            rising <= 1'b0;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_s <= s;
            // Detect rising water level (any sensor newly asserted)
            rising <= ((s[0] & ~prev_s[0]) | (s[1] & ~prev_s[1]) | (s[2] & ~prev_s[2]));
            
            // Nominal flow rates (registered outputs)
            case (s)
                3'b000: begin // Below s[0]
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                3'b001: begin // Between s[1] and s[0]
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                3'b011: begin // Between s[2] and s[1]
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                end
                3'b111: begin // Above s[2]
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
                default: begin // Maintain current state for invalid patterns
                    fr2 <= fr2;
                    fr1 <= fr1;
                    fr0 <= fr0;
                end
            endcase
            
            // Supplemental flow (active when rising and not at highest level)
            dfr <= rising && (s != 3'b111);
        end
    end

endmodule