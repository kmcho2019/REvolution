module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

enum {IDLE, S1, S2, S3, S4} state, next_state;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        sequence_detected <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    state <= S3;
                end else begin
                    state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    state <= S4;
                end else begin
                    state <= IDLE;
                end
            end
            S4: begin
                state <= IDLE;
                sequence_detected <= 1;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule