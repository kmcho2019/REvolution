module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Define an enumeration for the states
enum logic [1:0] {
    S0,
    S1,
    S2,
    S3,
    S4
} state, next_state;

// Next state logic
always_comb begin
    case (state)
        S0: begin
            next_state = data ? S1 : S0;
        end
        S1: begin
            next_state = data ? S2 : S0;
        end
        S2: begin
            next_state = data ? S1 : S3;
        end
        S3: begin
            next_state = data ? S4 : S0;
        end
        S4: begin
            next_state = S4;
        end
        default: next_state = S0;
    endcase
end

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == S4) begin
            start_shifting <= 1;
        end
    end
end

endmodule