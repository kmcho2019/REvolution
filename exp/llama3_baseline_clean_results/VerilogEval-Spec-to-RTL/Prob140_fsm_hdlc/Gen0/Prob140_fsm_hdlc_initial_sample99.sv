module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic in,
    output logic disc,
    output logic flag,
    output logic err
);

// Enum for states
enum logic [2:0] { IDLE, ONE, TWO, THREE, FOUR, FIVE, SIX, ERROR } state, next_state;

// Output logic
logic disc_next, flag_next, err_next;

// Current state logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= next_state;
        disc <= disc_next;
        flag <= flag_next;
        err <= err_next;
    end
end

// Next state and output logic
always_comb begin
    disc_next = 1'b0;
    flag_next = 1'b0;
    err_next = 1'b0;
    
    case (state)
        IDLE: begin
            if (in) next_state = ONE;
            else next_state = IDLE;
        end
        ONE: begin
            if (in) next_state = TWO;
            else next_state = IDLE;
        end
        TWO: begin
            if (in) next_state = THREE;
            else next_state = IDLE;
        end
        THREE: begin
            if (in) next_state = FOUR;
            else next_state = IDLE;
        end
        FOUR: begin
            if (in) next_state = FIVE;
            else next_state = IDLE;
        end
        FIVE: begin
            if (in) next_state = SIX;
            else begin
                next_state = IDLE;
                disc_next = 1'b1; // Discard condition met
            end
        end
        SIX: begin
            if (in) next_state = ERROR;
            else begin
                next_state = IDLE;
                flag_next = 1'b1; // Flag condition met
            end
        end
        ERROR: begin
            if (in) next_state = ERROR;
            else next_state = IDLE;
            err_next = 1'b1; // Error condition met
        end
    endcase
end

endmodule