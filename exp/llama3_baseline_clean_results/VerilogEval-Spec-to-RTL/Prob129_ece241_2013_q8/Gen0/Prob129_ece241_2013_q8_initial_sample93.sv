module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

// Define states
enum logic [1:0] {S0, S1, S2} state, nextState;

// State register
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= S0;
    end else begin
        state <= nextState;
    end
end

// Next state logic
always_comb begin
    case (state)
        S0: begin
            if (x) begin
                nextState = S1;
            end else begin
                nextState = S0;
            end
        end
        S1: begin
            if (!x) begin
                nextState = S2;
            end else begin
                nextState = S1;
            end
        end
        S2: begin
            if (x) begin
                nextState = S1;
                z = 1'b1;  // Assert output when "101" sequence is detected
            end else begin
                nextState = S0;
                z = 1'b0;
            end
        end
        default: begin
            nextState = S0;
            z = 1'b0;
        end
    endcase
end

// Add output z to be '0' in other cases
always_comb begin
    case (state)
        S0, S1: z = 1'b0;
        S2: begin
            if (x) begin
                z = 1'b1;
            end else begin
                z = 1'b0;
            end
        end
        default: z = 1'b0;
    endcase
end

endmodule