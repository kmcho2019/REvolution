module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// Define states
enum logic [1:0] {
    IDLE,
    S1,
    S2,
    S3,
    FOUND
} state, next_state;

// Output logic
assign start_shifting = (state == FOUND);

// State machine logic
always_comb begin
    case(state)
        IDLE: begin
            if(data) next_state = S1;
            else next_state = IDLE;
        end
        S1: begin
            if(data) next_state = S2;
            else next_state = IDLE;
        end
        S2: begin
            if(~data) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if(data) next_state = FOUND;
            else next_state = IDLE;
        end
        FOUND: next_state = FOUND;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if(reset) state <= IDLE;
    else state <= next_state;
end

endmodule