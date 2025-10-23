module fsm(
    input  logic IN,
    input  logic CLK,
    input  logic RST,
    output logic MATCH
);

// Define the states of the FSM
localparam NUM_STATES = 6;
enum logic [2:0] {
    IDLE  = 3'b000,
    STATE1 = 3'b001,
    STATE2 = 3'b010,
    STATE3 = 3'b011,
    STATE4 = 3'b100,
    STATE5 = 3'b101
} state, next_state;

// Define the state register
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Define the next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (IN) begin
                next_state = STATE1;
            end else begin
                next_state = IDLE;
            end
        end
        STATE1: begin
            if (~IN) begin
                next_state = STATE2;
            end else begin
                next_state = IDLE;
            end
        end
        STATE2: begin
            if (~IN) begin
                next_state = STATE3;
            end else begin
                next_state = IDLE;
            end
        end
        STATE3: begin
            if (IN) begin
                next_state = STATE4;
            end else begin
                next_state = IDLE;
            end
        end
        STATE4: begin
            if (IN) begin
                next_state = STATE5;
            end else begin
                next_state = IDLE;
            end
        end
        STATE5: begin
            if (IN) begin
                next_state = STATE5; // Stay in this state if IN is 1
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Define the output logic
assign MATCH = (state == STATE5);

endmodule