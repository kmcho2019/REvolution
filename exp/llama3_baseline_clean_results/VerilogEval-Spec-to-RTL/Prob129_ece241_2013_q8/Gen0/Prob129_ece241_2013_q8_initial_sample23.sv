module TopModule (
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

// Asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// State transitions and output logic
always @(*) begin
    next_state = state;
    z = 1'b0;
    case (state)
        S0: begin
            if (x) begin
                next_state = S1;
            end
        end
        S1: begin
            if (!x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x) begin
                z = 1'b1;
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        default: next_state = S0;
    endcase
end

endmodule