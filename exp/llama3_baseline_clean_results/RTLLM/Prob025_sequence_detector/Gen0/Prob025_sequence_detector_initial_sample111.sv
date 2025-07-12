module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Enum for states
enum logic [2:0] {IDLE, S1, S2, S3, S4} state, next_state;

// Output signal
logic sequence_detected_reg;

// State register
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (data_in == 1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (data_in == 0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in == 1) begin
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

// Output logic
always_comb begin
    case (state)
        S4: sequence_detected_reg = 1'b1;
        default: sequence_detected_reg = 1'b0;
    endcase
end

// Output assignment
assign sequence_detected = sequence_detected_reg;

endmodule