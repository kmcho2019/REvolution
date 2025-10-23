module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

state_t state, next_state;

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (~reset_n) begin
        state <= IDLE;
        shift_reg <= 4'b0000;
    end else begin
        state <= next_state;
        shift_reg <= {data_in, shift_reg[3:1]};
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            next_state = IDLE;
        end
    endcase
end

assign sequence_detected = (state == S4) || (shift_reg == 4'b1001);

endmodule