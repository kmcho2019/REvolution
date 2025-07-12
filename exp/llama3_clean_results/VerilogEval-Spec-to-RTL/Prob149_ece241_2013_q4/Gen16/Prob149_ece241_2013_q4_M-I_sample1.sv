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
        case (state)
            2'b00: begin // Below s[0]
                if (s[0]) begin
                    state <= 2'b01;
                end
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end
            2'b01: begin // Between s[0] and s[1]
                if (s[1]) begin
                    state <= 2'b10;
                end else if (!s[0]) begin
                    state <= 2'b00;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end
            2'b10: begin // Between s[1] and s[2]
                if (s[2]) begin
                    state <= 2'b11;
                end else if (!s[1]) begin
                    state <= 2'b01;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end
            2'b11: begin // Above s[2]
                if (!s[2]) begin
                    state <= 2'b10;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase

        // Update prev_state
        prev_state <= state;

        // Update dfr based on state transition
        if (state > prev_state) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
    end
end

endmodule