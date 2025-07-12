module pulse_detect(
    input  clk,
    input  rst_n,
    input  data_in,
    output data_out
);

// Enum for states
enum logic [1:0] {
    IDLE,
    RISING,
    FALLING
} state, next_state;

// Output signal
logic data_out_next;

// Combinational logic for next state and output
always_comb begin
    case(state)
        IDLE: begin
            if (data_in) begin
                next_state = RISING;
                data_out_next = 0;
            end else begin
                next_state = IDLE;
                data_out_next = 0;
            end
        end
        RISING: begin
            if (~data_in) begin
                next_state = FALLING;
                data_out_next = 1;
            end else begin
                next_state = RISING;
                data_out_next = 0;
            end
        end
        FALLING: begin
            next_state = IDLE;
            data_out_next = 0;
        end
        default: begin
            next_state = IDLE;
            data_out_next = 0;
        end
    endcase
end

// Sequential logic for state update
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        data_out <= data_out_next;
    end
end

endmodule