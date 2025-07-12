module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Priority Encoder
reg [1:0] state_code;
always @(*) begin
    if (s[2]) begin
        state_code = 2'b00; // ABOVE_HIGH
    end else if (s[1]) begin
        state_code = 2'b01; // BETWEEN_HIGH_AND_MIDDLE
    end else if (s[0]) begin
        state_code = 2'b10; // BETWEEN_MIDDLE_AND_LOW
    end else begin
        state_code = 2'b11; // BELOW_LOW
    end
end

// Finite State Machine (FSM)
reg [1:0] current_state;
reg [1:0] previous_state;
always @(posedge clk) begin
    if (reset) begin
        current_state <= 2'b11; // BELOW_LOW
        previous_state <= 2'b11; // BELOW_LOW
    end else begin
        previous_state <= current_state;
        current_state <= state_code;
    end
end

// Sensor Change Detection
reg previous_s;
always @(posedge clk) begin
    if (reset) begin
        previous_s <= 1'b0;
    end else begin
        previous_s <= s[0] | s[1] | s[2];
    end
end

// Output Signal Generator
always @(*) begin
    case (current_state)
        2'b00: begin // ABOVE_HIGH
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end
        2'b01: begin // BETWEEN_HIGH_AND_MIDDLE
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            dfr <= (s[0] | s[1] | s[2]) > previous_s;
        end
        2'b10: begin // BETWEEN_MIDDLE_AND_LOW
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= (s[0] | s[1] | s[2]) > previous_s;
        end
        2'b11: begin // BELOW_LOW
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= (s[0] | s[1] | s[2]) > previous_s;
        end
    endcase
end

endmodule