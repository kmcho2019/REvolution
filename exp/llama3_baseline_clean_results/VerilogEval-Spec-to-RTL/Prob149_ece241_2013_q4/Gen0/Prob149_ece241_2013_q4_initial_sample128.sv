module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] state, next_state;

// Reset the state machine to its initial state
initial state = 3'b111;

// Determine the next state based on the current state and sensor inputs
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        state <= next_state;
        case (state)
            3'b000: begin // Below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
                if (s[0] == 1'b1) begin
                    next_state <= 3'b001;
                end else begin
                    next_state <= 3'b000;
                end
            end
            3'b001: begin // Between s[1] and s[0]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (s[1] == 1'b1) begin
                    next_state <= 3'b010;
                end else if (s[0] == 1'b0) begin
                    next_state <= 3'b000;
                end else begin
                    next_state <= 3'b001;
                end
                if (s[1] == 1'b1 && state == 3'b001) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            3'b010: begin // Between s[2] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (s[2] == 1'b1) begin
                    next_state <= 3'b011;
                end else if (s[1] == 1'b0) begin
                    next_state <= 3'b001;
                end else begin
                    next_state <= 3'b010;
                end
                if (s[2] == 1'b1 && state == 3'b010) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            3'b011: begin // Above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
                if (s[2] == 1'b0) begin
                    next_state <= 3'b010;
                end else begin
                    next_state <= 3'b011;
                end
            end
        endcase
    end
end

endmodule