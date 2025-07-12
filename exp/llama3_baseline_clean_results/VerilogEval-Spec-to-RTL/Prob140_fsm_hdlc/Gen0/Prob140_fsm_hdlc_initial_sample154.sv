module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    ONE = 3'b001,
    TWO = 3'b010,
    THREE = 3'b011,
    FOUR = 3'b100,
    FIVE = 3'b101,
    SIX = 3'b110,
    FLAG = 3'b111,
    ERROR = 3'b1000
} state, next_state;

// Register to hold the current state
logic [2:0] state_reg;

// Outputs
logic disc_reg, flag_reg, err_reg;

// Assign outputs to registered values
assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

// Sequential logic to update the state and outputs
always_ff @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        disc_reg <= 1'b0;
        flag_reg <= 1'b0;
        err_reg <= 1'b0;
    end else begin
        state_reg <= state;
        disc_reg <= 1'b0;
        flag_reg <= 1'b0;
        err_reg <= 1'b0;
        case (state)
            IDLE: begin
                if (in) begin
                    state_reg <= ONE;
                end
            end
            ONE: begin
                if (in) begin
                    state_reg <= TWO;
                end else begin
                    state_reg <= IDLE;
                end
            end
            TWO: begin
                if (in) begin
                    state_reg <= THREE;
                end else begin
                    state_reg <= IDLE;
                end
            end
            THREE: begin
                if (in) begin
                    state_reg <= FOUR;
                end else begin
                    state_reg <= IDLE;
                end
            end
            FOUR: begin
                if (in) begin
                    state_reg <= FIVE;
                end else begin
                    state_reg <= IDLE;
                end
            end
            FIVE: begin
                if (in) begin
                    state_reg <= SIX;
                end else begin
                    state_reg <= IDLE;
                    disc_reg <= 1'b1;
                end
            end
            SIX: begin
                if (in) begin
                    state_reg <= FLAG;
                end else begin
                    state_reg <= IDLE;
                    flag_reg <= 1'b1;
                end
            end
            FLAG: begin
                if (in) begin
                    state_reg <= ERROR;
                end else begin
                    state_reg <= IDLE;
                end
            end
            ERROR: begin
                if (in) begin
                    state_reg <= ERROR;
                end else begin
                    state_reg <= IDLE;
                end
                err_reg <= 1'b1;
            end
            default: begin
                state_reg <= IDLE;
            end
        endcase
    end
end

// Combinational logic to update the next state
always_comb begin
    case (state_reg)
        IDLE: state = IDLE;
        ONE: state = ONE;
        TWO: state = TWO;
        THREE: state = THREE;
        FOUR: state = FOUR;
        FIVE: state = FIVE;
        SIX: state = SIX;
        FLAG: state = FLAG;
        ERROR: state = ERROR;
        default: state = IDLE;
    endcase
end

endmodule