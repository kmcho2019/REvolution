module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define states
enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state, next_state;

// State machine logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1'b1)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1: begin
            if (data_in == 1'b0)
                next_state = S2;
            else
                next_state = IDLE;
        end
        S2: begin
            if (data_in == 1'b0)
                next_state = S2;
            else if (data_in == 1'b1)
                next_state = S3;
            else
                next_state = IDLE;
        end
        S3: begin
            if (data_in == 1'b1)
                next_state = S4;
            else
                next_state = IDLE;
        end
        S4: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Update state on clock edge
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        state <= next_state;
        if (state == S4)
            sequence_detected <= 1'b1;
        else
            sequence_detected <= 1'b0;
    end
end

endmodule