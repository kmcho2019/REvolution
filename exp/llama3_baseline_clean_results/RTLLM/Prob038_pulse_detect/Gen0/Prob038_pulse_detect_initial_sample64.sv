module pulse_detect (
    input  clk,
    input  rst_n,
    input  data_in,
    output data_out
);

// Enum for states
enum logic [1:0] {
    IDLE = 2'b00,
    RISING = 2'b01,
    FALLING = 2'b10
} state, next_state;

// Combinational logic for next state
always_comb begin
    case (state)
        IDLE: begin
            if (data_in) begin
                next_state = RISING;
            end else begin
                next_state = IDLE;
            end
        end
        RISING: begin
            if (data_in) begin
                next_state = RISING;
            end else begin
                next_state = FALLING;
            end
        end
        FALLING: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic for state and output
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        case (next_state)
            IDLE: data_out <= 1'b0;
            RISING: data_out <= 1'b0;
            FALLING: data_out <= 1'b1;
            default: data_out <= 1'b0;
        endcase
    end
end

endmodule