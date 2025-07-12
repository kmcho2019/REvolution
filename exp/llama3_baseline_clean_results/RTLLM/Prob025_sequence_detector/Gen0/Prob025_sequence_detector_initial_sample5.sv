module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Enumerate the states of the FSM
enum logic [2:0] {IDLE, S1, S2, S3, S4} state, next_state;

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
            next_state = IDLE;
        end
    endcase
end

always @(posedge clk, negedge reset_n) begin
    if(!reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        state <= next_state;
        case(state)
            S4: sequence_detected <= 1'b1;
            default: sequence_detected <= 1'b0;
        endcase
    end
end

endmodule