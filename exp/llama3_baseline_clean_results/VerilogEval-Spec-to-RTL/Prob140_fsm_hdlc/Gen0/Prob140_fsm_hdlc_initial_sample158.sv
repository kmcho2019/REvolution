module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

// Define the states
enum logic [2:0] {
    S_IDLE = 3'b000, // Initial state, no consecutive 1s
    S_ONE = 3'b001,  // One consecutive 1
    S_TWO = 3'b010,  // Two consecutive 1s
    S_THREE = 3'b011, // Three consecutive 1s
    S_FOUR = 3'b100,  // Four consecutive 1s
    S_FIVE = 3'b101,  // Five consecutive 1s
    S_FLAG = 3'b110,  // Six consecutive 1s, flag detected
    S_ERROR = 3'b111  // Seven or more consecutive 1s, error detected
} state, next_state;

// Output signals
logic disc_reg, flag_reg, err_reg;

// Next-state logic
always_comb begin
    case (state)
        S_IDLE: begin
            if (in) begin
                next_state = S_ONE;
            end else begin
                next_state = S_IDLE;
            end
        end
        S_ONE: begin
            if (in) begin
                next_state = S_TWO;
            end else begin
                next_state = S_IDLE;
            end
        end
        S_TWO: begin
            if (in) begin
                next_state = S_THREE;
            end else begin
                next_state = S_IDLE;
            end
        end
        S_THREE: begin
            if (in) begin
                next_state = S_FOUR;
            end else begin
                next_state = S_IDLE;
            end
        end
        S_FOUR: begin
            if (in) begin
                next_state = S_FIVE;
            end else begin
                next_state = S_IDLE;
            end
        end
        S_FIVE: begin
            if (in) begin
                next_state = S_FLAG;
            end else begin
                next_state = S_IDLE;
            end
        end
        S_FLAG: begin
            if (in) begin
                next_state = S_ERROR;
            end else begin
                next_state = S_IDLE;
            end
        end
        S_ERROR: begin
            if (!in) begin
                next_state = S_IDLE;
            end else begin
                next_state = S_ERROR;
            end
        end
        default: next_state = S_IDLE;
    endcase
end

// Output logic
always_comb begin
    case (state)
        S_FLAG: begin
            flag_reg = 1'b1;
            disc_reg = 1'b0;
            err_reg = 1'b0;
        end
        S_ERROR: begin
            flag_reg = 1'b0;
            disc_reg = 1'b0;
            err_reg = 1'b1;
        end
        S_FIVE: begin
            flag_reg = 1'b0;
            disc_reg = 1'b1;
            err_reg = 1'b0;
        end
        default: begin
            flag_reg = 1'b0;
            disc_reg = 1'b0;
            err_reg = 1'b0;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= S_IDLE;
        flag <= 1'b0;
        disc <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= next_state;
        flag <= flag_reg;
        disc <= disc_reg;
        err <= err_reg;
    end
end

endmodule