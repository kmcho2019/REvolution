module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Declare the states of the FSM
enum logic [1:0] {
    IDLE = 2'b00,
    PULSE_START = 2'b01,
    PULSE_MIDDLE = 2'b10,
    PULSE_END = 2'b11
} state, next_state;

// Declare the output register
reg data_out_reg;
assign data_out = data_out_reg;

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= PULSE_START;
                    data_out_reg <= 0;
                end else begin
                    state <= IDLE;
                    data_out_reg <= 0;
                end
            end
            PULSE_START: begin
                if (data_in) begin
                    state <= PULSE_MIDDLE;
                    data_out_reg <= 0;
                end else begin
                    state <= IDLE;
                    data_out_reg <= 0;
                end
            end
            PULSE_MIDDLE: begin
                if (~data_in) begin
                    state <= PULSE_END;
                    data_out_reg <= 1;
                end else begin
                    state <= PULSE_MIDDLE;
                    data_out_reg <= 0;
                end
            end
            PULSE_END: begin
                state <= IDLE;
                data_out_reg <= 0;
            end
        endcase
    end
end

endmodule