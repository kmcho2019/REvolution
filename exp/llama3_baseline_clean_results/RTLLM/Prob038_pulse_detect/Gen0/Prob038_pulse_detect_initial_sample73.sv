module pulse_detect(
    input  clk,
    input  rst_n,
    input  data_in,
    output data_out
);

enum logic [1:0] {IDLE, RISE, FALL} state, next_state;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        case(state)
            IDLE: begin
                if (data_in) begin
                    data_out <= 1'b0;
                    next_state <= RISE;
                end else begin
                    data_out <= 1'b0;
                    next_state <= IDLE;
                end
            end
            RISE: begin
                if (~data_in) begin
                    data_out <= 1'b0;
                    next_state <= FALL;
                end else begin
                    data_out <= 1'b0;
                    next_state <= RISE;
                end
            end
            FALL: begin
                data_out <= 1'b1;
                next_state <= IDLE;
            end
            default: begin
                data_out <= 1'b0;
                next_state <= IDLE;
            end
        endcase
    end
end

endmodule