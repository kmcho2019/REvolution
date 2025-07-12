module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b110; // Reset to state equivalent to low water level
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (state)
            3'b000: begin // State 0: All sensors are high
                if (s == 3'b111) begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end else if (s == 3'b110) begin
                    state <= 3'b001; // Transition to State 1
                end
            end
            3'b001: begin // State 1: Sensors s[1:0] are high, s[2] is low
                if (s == 3'b110) begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else if (s == 3'b011) begin
                    state <= 3'b010; // Transition to State 2
                end else if (s == 3'b100) begin
                    state <= 3'b000; // Transition to State 0
                end
            end
            3'b010: begin // State 2: Sensor s[0] is high, s[1:2] are low
                if (s == 3'b011) begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else if (s == 3'b001) begin
                    state <= 3'b011; // Transition to State 3
                end else if (s == 3'b110) begin
                    state <= 3'b001; // Transition to State 1
                end
            end
            3'b011: begin // State 3: No sensors are high
                if (s == 3'b000) begin
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else if (s == 3'b001) begin
                    state <= 3'b010; // Transition to State 2
                end
            end
            3'b100: begin // State 4: Transition from a lower state to a higher state
                dfr <= 1'b1;
                if (s == 3'b111) begin
                    state <= 3'b000; // Transition to State 0
                end else if (s == 3'b110) begin
                    state <= 3'b001; // Transition to State 1
                end else if (s == 3'b011) begin
                    state <= 3'b010; // Transition to State 2
                end
            end
            3'b101: begin // State 5: Transition from a higher state to a lower state
                dfr <= 1'b0;
                if (s == 3'b000) begin
                    state <= 3'b011; // Transition to State 3
                end else if (s == 3'b001) begin
                    state <= 3'b010; // Transition to State 2
                end else if (s == 3'b011) begin
                    state <= 3'b001; // Transition to State 1
                end
            end
            3'b110: begin // State 6: Reset state
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
                if (s == 3'b000) begin
                    state <= 3'b011; // Transition to State 3
                end
            end
        endcase
    end
end

endmodule