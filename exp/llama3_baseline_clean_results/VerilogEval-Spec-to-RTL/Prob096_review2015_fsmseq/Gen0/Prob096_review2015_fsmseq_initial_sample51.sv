module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Enum for states
enum logic [1:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state, next_state;

always @(*) begin
    case(state)
        IDLE: begin
            if(data == 1) next_state = S1;
            else next_state = IDLE;
            start_shifting = 0;
        end
        S1: begin
            if(data == 1) next_state = S2;
            else next_state = IDLE;
            start_shifting = 0;
        end
        S2: begin
            if(data == 0) next_state = S3;
            else next_state = S1;
            start_shifting = 0;
        end
        S3: begin
            if(data == 1) next_state = S4;
            else next_state = IDLE;
            start_shifting = 0;
        end
        S4: begin
            next_state = S4;
            start_shifting = 1;
        end
        default: begin
            next_state = IDLE;
            start_shifting = 0;
        end
    endcase
end

always @(posedge clk) begin
    if(reset) state <= IDLE;
    else state <= next_state;
end

endmodule