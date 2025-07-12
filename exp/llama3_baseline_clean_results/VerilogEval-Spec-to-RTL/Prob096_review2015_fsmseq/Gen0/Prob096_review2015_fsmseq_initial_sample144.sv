module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the states
enum logic [2:0] {
    S0 = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state, next_state;

always_comb begin
    case(state)
        S0: begin
            if(data == 1'b1) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if(data == 1'b1) next_state = S2;
            else next_state = S0;
        end
        S2: begin
            if(data == 1'b0) next_state = S3;
            else if(data == 1'b1) next_state = S2; // Incorrect sequence, restart
            else next_state = S2;
        end
        S3: begin
            if(data == 1'b1) next_state = S4;
            else next_state = S0; // Incorrect sequence, restart
        end
        S4: next_state = S4; // Stay in this state until reset
        default: next_state = S0;
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= S0;
        start_shifting <= 0;
    end
    else begin
        state <= next_state;
        if(state == S4) start_shifting <= 1'b1;
        else if(next_state == S4) start_shifting <= 1'b1;
        else start_shifting <= 1'b0;
    end
end

endmodule