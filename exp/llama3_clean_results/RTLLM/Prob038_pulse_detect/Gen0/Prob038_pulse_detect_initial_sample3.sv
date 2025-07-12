module pulse_detect(
    input  clk,
    input  rst_n,
    input  data_in,
    output data_out
);

// Define states for the finite state machine
enum logic [1:0] {
    IDLE = 2'b00,
    RISING = 2'b01,
    HIGH = 2'b10,
    FALLING = 2'b11
} state, next_state;

// Output register
reg data_out_reg;

// Next state logic and output logic
always_comb begin
    case (state)
        IDLE: begin
            if (data_in) begin
                next_state = RISING;
            end else begin
                next_state = IDLE;
            end
            data_out_reg = 1'b0;
        end
        RISING: begin
            if (data_in) begin
                next_state = HIGH;
            end else begin
                next_state = IDLE;
            end
            data_out_reg = 1'b0;
        end
        HIGH: begin
            if (data_in) begin
                next_state = HIGH;
            end else begin
                next_state = FALLING;
            end
            data_out_reg = 1'b0;
        end
        FALLING: begin
            next_state = IDLE;
            data_out_reg = 1'b1;
        end
        default: begin
            next_state = IDLE;
            data_out_reg = 1'b0;
        end
    endcase
end

// State register
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        data_out <= data_out_reg;
    end
end

endmodule