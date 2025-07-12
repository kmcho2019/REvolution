module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Enum for the states
enum logic [1:0] {IDLE, RISING, FALLING} state, next_state;

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
            if (~data_in) begin
                next_state = FALLING;
            end else begin
                next_state = RISING;
            end
        end
        FALLING: begin
            if (~data_in) begin
                next_state = IDLE;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic for state and output
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        case (next_state)
            IDLE: begin
                if (state == FALLING) begin
                    data_out <= 1;
                end else begin
                    data_out <= 0;
                end
            end
            default: data_out <= 0;
        endcase
    end
end

endmodule