module sequence_detector(
    input           clk,        // Clock signal
    input           reset_n,    // Reset signal
    input           data_in,    // 1-bit binary input signal
    output reg      sequence_detected // 1-bit output signal
);

// Define states
parameter IDLE = 4'd0;
parameter S1   = 4'd1;
parameter S2   = 4'd2;
parameter S3   = 4'd3;
parameter S4   = 4'd4;

reg [3:0] current_state; // Current state of the FSM
reg [3:0] next_state;    // Next state of the FSM

// State transition logic
always @(*) begin
    case(current_state)
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
                next_state = S1;
        end
        S2: begin
            if (data_in == 1'b0)
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

// State update logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        if (current_state == S4)
            sequence_detected <= 1'b1;
        else
            sequence_detected <= 1'b0;
    end
end

endmodule