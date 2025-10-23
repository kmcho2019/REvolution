module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define states
enum logic [1:0] {
    S0 = 2'b00,
    S1 = 2'b01,
    S2 = 2'b10
} state, next_state;

// State register
always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// Next state and output logic
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
            if (~x) begin
                next_state = S2;
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