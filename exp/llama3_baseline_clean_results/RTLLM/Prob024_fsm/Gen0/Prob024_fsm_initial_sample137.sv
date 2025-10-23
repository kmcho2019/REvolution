module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
parameter S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5;

reg [3:0] state, next_state;

// Initialize state
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        state <= next_state;
    end
end

// State transition logic
always @(*) begin
    next_state = state;
    MATCH = 0;
    case (state)
        S0: begin
            if (IN) next_state = S1;
        end
        S1: begin
            if (!IN) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if (!IN) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if (IN) next_state = S4;
            else next_state = S2;
        end
        S4: begin
            if (IN) begin
                next_state = S5;
                MATCH = 1;
            end else next_state = S0;
        end
        S5: begin
            if (IN) begin
                next_state = S1;
            end else next_state = S0;
        end
        default: next_state = S0;
    endcase
    if (RST) begin
        next_state = S0;
        MATCH = 0;
    end
end

endmodule