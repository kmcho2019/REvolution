module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state;
reg level_increasing;

// Sequential logic to update state and level_increasing
always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        state <= 2'b11;
        level_increasing <= 1'b0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (state)
            2'b00: // Above s[2]
                if (~s[2] && s[1] && s[0]) begin
                    state <= 2'b01;
                    level_increasing <= 1'b0;
                end
            2'b01: // Between s[2] and s[1]
                if (s[2] && s[1] && s[0]) begin
                    state <= 2'b00;
                    level_increasing <= 1'b1;
                end else if (~s[2] && ~s[1] && s[0]) begin
                    state <= 2'b10;
                    level_increasing <= 1'b0;
                end
            2'b10: // Between s[1] and s[0]
                if (~s[2] && s[1] && s[0]) begin
                    state <= 2'b01;
                    level_increasing <= 1'b1;
                end else if (~s[2] && ~s[1] && ~s[0]) begin
                    state <= 2'b11;
                    level_increasing <= 1'b0;
                end
            2'b11: // Below s[0]
                if (~s[2] && ~s[1] && s[0]) begin
                    state <= 2'b10;
                    level_increasing <= 1'b1;
                end
        endcase

        // Update output signals based on state and level_increasing
        case (state)
            2'b00: // Above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            2'b01: // Between s[2] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= level_increasing;
            2'b10: // Between s[1] and s[0]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increasing;
            2'b11: // Below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increasing;
        endcase
    end
end

endmodule