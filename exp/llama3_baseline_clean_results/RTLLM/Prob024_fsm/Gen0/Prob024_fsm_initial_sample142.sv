module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define states
parameter IDLE = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5;
reg [2:0] state, next_state;

// Define MATCH signal
reg match;

always @(*) begin
    case(state)
        IDLE: begin
            if (IN == 1) next_state = S1;
            else next_state = IDLE;
            match = 0;
        end
        S1: begin
            if (IN == 0) next_state = S2;
            else next_state = IDLE;
            match = 0;
        end
        S2: begin
            if (IN == 0) next_state = S3;
            else next_state = IDLE;
            match = 0;
        end
        S3: begin
            if (IN == 1) next_state = S4;
            else next_state = IDLE;
            match = 0;
        end
        S4: begin
            if (IN == 1) next_state = S5;
            else next_state = IDLE;
            match = 0;
        end
        S5: begin
            if (IN == 1) next_state = S5;
            else next_state = IDLE;
            match = 1;
        end
        default: begin
            next_state = IDLE;
            match = 0;
        end
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 0;
    end else begin
        state <= next_state;
        MATCH <= match;
    end
end

endmodule