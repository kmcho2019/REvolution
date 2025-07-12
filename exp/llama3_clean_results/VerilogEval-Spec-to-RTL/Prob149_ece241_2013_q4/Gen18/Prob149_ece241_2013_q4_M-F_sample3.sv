module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state; // 0: below s[0], 1: between s[0] and s[1], 2: between s[1] and s[2], 3: above s[2]
reg [1:0] prev_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state below s[0]
        prev_state <= 2'b00;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Update prev_state before state transition
        prev_state <= state;

        case (s)
            3'b000: begin // Below s[0]
                state <= 2'b00;
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end
            3'b001: begin // Between s[0] and s[1]
                if (prev_state == 2'b00) begin // Rising level
                    state <= 2'b01;
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else if (prev_state == 2'b01) begin // No change
                    state <= 2'b01;
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else if (prev_state == 2'b10) begin // Falling level
                    state <= 2'b01;
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else if (prev_state == 2'b11) begin // Falling level
                    state <= 2'b01;
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end
            end
            3'b011: begin // Between s[1] and s[2]
                if (prev_state == 2'b01) begin // Rising level
                    state <= 2'b10;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else if (prev_state == 2'b10) begin // No change
                    state <= 2'b10;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else if (prev_state == 2'b00) begin // Rising level
                    state <= 2'b10;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else if (prev_state == 2'b11) begin // Falling level
                    state <= 2'b10;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end
            end
            3'b111: begin // Above s[2]
                state <= 2'b11;
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                if (prev_state == 2'b10) begin // Rising level
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            default: begin // Other cases
                state <= 2'b11;
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule