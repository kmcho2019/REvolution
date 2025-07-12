module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Declare states
enum logic [1:0] {
    IDLE = 2'b00,
    RISING = 2'b01,
    HIGH = 2'b10,
    FALLING = 2'b11
} state, next_state;

// Output signal
logic data_out_reg, data_out_next;

// Combinational logic for next state and output
always_comb begin
    next_state = state;
    data_out_next = 0;

    case (state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = RISING;
            end else begin
                next_state = IDLE;
            end
        end
        RISING: begin
            if (data_in == 1'b1) begin
                next_state = HIGH;
            end else begin
                next_state = IDLE;
            end
        end
        HIGH: begin
            if (data_in == 1'b1) begin
                next_state = HIGH;
            end else begin
                next_state = FALLING;
            end
        end
        FALLING: begin
            data_out_next = 1'b1;
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic for state and output
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out_reg <= 1'b0;
    end else begin
        state <= next_state;
        data_out_reg <= data_out_next;
    end
end

// Output assignment
assign data_out = data_out_reg;

endmodule