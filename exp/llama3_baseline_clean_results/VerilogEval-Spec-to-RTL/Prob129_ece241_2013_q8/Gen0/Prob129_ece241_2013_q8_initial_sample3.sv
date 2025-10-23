module TopModule (
    input           clk,
    input           aresetn,
    input           x,
    output reg      z
);

// Define states
enum logic [1:0] { S0, S1, S2 } state, next_state;

// State register with asynchronous reset
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        S0: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = S0;
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
                next_state = S0; // Recognized sequence '101'
            end else begin
                next_state = S0; // Sequence not recognized, reset to S0
            end
        end
        default: next_state = S0;
    endcase
end

// Output logic
always_comb begin
    case (state)
        S0: z = 1'b0;
        S1: z = 1'b0;
        S2: z = x; // Assert z if sequence '101' is recognized
        default: z = 1'b0;
    endcase
end

endmodule