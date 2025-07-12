module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

// Define states for the state machine
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4,
    MATCH_STATE
} state, next_state;

// Shift register logic using continuous assignment
reg [4:0] shift_reg;
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        shift_reg <= 5'b00000; // Reset shift register
    end else begin
        shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
    end
end

// State machine logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= IDLE; // Reset state machine
    end else begin
        state <= next_state; // Update state
    end
end

// Combinational logic for next state
always @(*) begin
    case(state)
        IDLE: begin
            if(IN == 1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if(IN == 0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if(IN == 0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if(IN == 1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            if(IN == 1) begin
                next_state = MATCH_STATE;
            end else begin
                next_state = IDLE;
            end
        end
        MATCH_STATE: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Combinational logic for MATCH signal
assign MATCH = (state == MATCH_STATE)? 1'b1 : 1'b0;

endmodule