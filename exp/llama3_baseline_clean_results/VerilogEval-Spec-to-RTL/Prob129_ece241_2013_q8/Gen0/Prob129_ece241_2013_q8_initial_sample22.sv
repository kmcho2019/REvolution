module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

// Define the states
enum logic [1:0] {
    S0 = 2'b00,
    S1 = 2'b01,
    S2 = 2'b10
} state, next_state;

// Mealy-type state machine
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and output
always @(*) begin
    case(state)
        S0: begin
            if (x) begin
                next_state = S1;
                z = 1'b0;
            end else begin
                next_state = S0;
                z = 1'b0;
            end
        end
        S1: begin
            if (x) begin
                next_state = S1;
                z = 1'b0;
            end else begin
                next_state = S2;
                z = 1'b0;
            end
        end
        S2: begin
            if (x) begin
                next_state = S1;
                z = 1'b1;
            end else begin
                next_state = S0;
                z = 1'b0;
            end
        end
    endcase
end

endmodule