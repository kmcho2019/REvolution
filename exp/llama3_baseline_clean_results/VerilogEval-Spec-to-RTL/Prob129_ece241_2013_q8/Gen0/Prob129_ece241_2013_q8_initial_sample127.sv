module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

// Define the states
enum logic [1:0] {S0, S1, S2} state, next_state;

// Mealy-type FSM
always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case(state)
        S0: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (~x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        default: begin
            next_state = S0;
        end
    endcase
end

// Mealy-type output logic
always_comb begin
    case(state)
        S0: z = 1'b0;
        S1: z = 1'b0;
        S2: z = x;
        default: z = 1'b0;
    endcase
end

endmodule