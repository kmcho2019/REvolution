module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Enumerate the states of the FSM
enum logic [2:0] {IDLE, S1, S2, S3, S4} state, next_state;

// Default output
always @(*) begin
    sequence_detected = 1'b0;
end

// FSM state transition logic
always @(*) begin
    case(state)
        IDLE: begin
            if(data_in == 1'b1) next_state = S1;
            else next_state = IDLE;
        end
        S1: begin
            if(data_in == 1'b0) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if(data_in == 1'b0) next_state = S2;
            else next_state = S3;
        end
        S3: begin
            if(data_in == 1'b1) next_state = S4;
            else next_state = IDLE;
        end
        S4: begin
            sequence_detected = 1'b1;
            next_state = IDLE;
        end
    endcase
end

// FSM state update logic
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end

endmodule