module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define the states for the FSM
parameter IDLE = 4'b0000,
          S1   = 4'b0001,
          S2   = 4'b0010,
          S3   = 4'b0100,
          S4   = 4'b1000,
          MATCH_STATE = 4'b1001;

reg [3:0] state, next_state;

// Output signal
reg match;

// Sequential logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        match <= 0;
    end else begin
        state <= next_state;
        match <= (state == MATCH_STATE) ? 1 : 0;
    end
end

// Combinational logic
always @(*) begin
    case(state)
        IDLE: begin
            if (IN) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (!IN) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (!IN) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = S1;
            end
        end
        S4: begin
            if (IN) begin
                next_state = MATCH_STATE;
            end else begin
                next_state = S1;
            end
        end
        MATCH_STATE: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

assign MATCH = match;

endmodule