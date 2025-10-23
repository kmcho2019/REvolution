module sequence_detector (
    input clk, // Clock signal
    input reset_n, // Reset signal (active low)
    input data_in, // 1-bit binary input signal
    output reg sequence_detected // 1-bit output signal indicating sequence detection
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state, next_state;

// FSM state register
always @ (posedge clk) begin
    if (~reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// FSM next state logic
always @ (*) begin
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
                next_state = S1;
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
            next_state = IDLE; // Reset the sequence detection
        end
        default: next_state = IDLE;
    endcase
end

// Sequence detection output logic
always @ (posedge clk) begin
    if (state == S4) begin
        sequence_detected <= 1'b1;
    end else begin
        sequence_detected <= 1'b0;
    end
end

endmodule