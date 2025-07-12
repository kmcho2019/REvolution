module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100,
    S5 = 3'b101
} state, next_state;

// Assign the output signal MATCH based on the current state
assign MATCH = (state == S5);

// Sequential logic to update the state at every positive edge of the clock
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic to determine the next state based on the current state and input
always_comb begin
    case (state)
        IDLE: begin
            if (IN) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (~IN) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (~IN) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = S2;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
            end else begin
                next_state = S1;
            end
        end
        S5: begin
            if (IN) begin
                next_state = S5;
            end else begin
                next_state = S1;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule