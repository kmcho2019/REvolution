module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] currentState;
reg [2:0] previousSensors;

always @(posedge clk) begin
    if (reset) begin
        // Reset to state where water level is below s[0]
        currentState <= 3'b000;
        previousSensors <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Next state logic
        case (s)
            3'b111: currentState <= 3'b000; // Above s[2]
            3'b110: currentState <= 3'b001; // Between s[2] and s[1]
            3'b100: currentState <= 3'b001; // Between s[2] and s[1]
            3'b011: currentState <= 3'b010; // Between s[1] and s[0]
            3'b010: currentState <= 3'b010; // Between s[1] and s[0]
            3'b001: currentState <= 3'b011; // Between s[1] and s[0]
            3'b000: currentState <= 3'b100; // Below s[0]
            default: currentState <= currentState;
        endcase

        // Output logic
        case (currentState)
            3'b000: begin // Above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            3'b001: begin // Between s[2] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (s > previousSensors) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            3'b010: begin // Between s[1] and s[0]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (s > previousSensors) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            3'b100: begin // Below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            default: begin
                fr2 <= fr2;
                fr1 <= fr1;
                fr0 <= fr0;
                dfr <= dfr;
            end
        endcase

        // Store current sensor values for next clock cycle
        previousSensors <= s;
    end
end

endmodule