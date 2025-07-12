module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
enum logic [1:0] {
    S0 = 2'b00,
    S1 = 2'b01,
    S2 = 2'b10
} state, next_state;

// Asynchronous reset and sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        // Reset the state on asynchronous reset
        state <= S0;
    end else begin
        // Update the state on the positive clock edge
        state <= next_state;
    end
end

// Combinational logic for next state and output
always_comb begin
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
    endcase
end

endmodule