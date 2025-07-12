module pulse_detect (
    input  clk,
    input  rst_n,
    input  data_in,
    output data_out
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE,
    RISING,
    FALLING
} state, next_state;

// Always block for sequential logic
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        if (next_state == FALLING) begin
            data_out <= 1'b1;
        end else begin
            data_out <= 1'b0;
        end
    end
end

// Always block for combinational logic
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
            next_state = IDLE;
        end
    endcase
end

endmodule