module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

reg [1:0] current_state, next_state;

always @(posedge clk) begin
    current_state <= next_state;
end

always @(*) begin
    case(current_state)
        2'b00: begin // State S0
            if (a == 1'b1 && b == 1'b1) begin
                next_state <= 2'b00; // Stay in S0 if a=1 and b=1
            end else if (a == 1'b0 && b == 1'b0) begin
                next_state <= 2'b01; // Transition to S1 if a=0 and b=0
            end else begin
                next_state <= 2'b00; // Stay in S0 for other conditions
            end
            q <= b; // q follows b in S0
            state <= 1'b0; // state is 0 in S0
        end
        2'b01: begin // State S1
            if (a == 1'b1 && b == 1'b1) begin
                next_state <= 2'b00; // Transition to S0 if a=1 and b=1
            end else begin
                next_state <= 2'b01; // Stay in S1 for other conditions
            end
            q <= 1'b1; // q is always 1 in S1
            state <= 1'b1; // state is 1 in S1
        end
        default: begin
            next_state <= 2'b00; // Default to S0
            q <= 1'b0; // Default q to 0
            state <= 1'b0; // Default state to 0
        end
    endcase
end

initial begin
    current_state <= 2'b00; // Initialize to S0
end

endmodule