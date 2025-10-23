module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states of the FSM
parameter IDLE = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;
parameter S4 = 2'b10; // reuse S2 state for S4 to simplify logic

reg [1:0] current_state, next_state;

// Initialize the output
assign sequence_detected = (current_state == S4 && data_in == 1'b1);

// Define the FSM transitions
always @(*) begin
    case(current_state)
        IDLE: begin
            if(data_in == 1'b1)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1: begin
            if(data_in == 1'b0)
                next_state = S2;
            else
                next_state = IDLE;
        end
        S2: begin
            if(data_in == 1'b0)
                next_state = S3;
            else
                next_state = IDLE;
        end
        S3: begin
            if(data_in == 1'b1)
                next_state = S4;
            else
                next_state = IDLE;
        end
        S4: begin
            next_state = IDLE; // after detecting sequence, go back to IDLE
        end
        default: next_state = IDLE; // default to IDLE for any invalid state
    endcase
end

// Update the current state on every clock cycle
always @(posedge clk or negedge reset_n) begin
    if(!reset_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

endmodule