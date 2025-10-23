module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
enum logic [1:0] {S0, S1, S2} state, next_state;

// Initialize the state
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// State transitions and output logic
always @(*) begin
    case (state)
        S0: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
            z = 1'b0;
        end
        S1: begin
            if (~x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
            z = 1'b0;
        end
        S2: begin
            if (x) begin
                next_state = S1;  // Start looking for the next '1' after detecting '101'
            end else begin
                next_state = S2;
            end
            z = x;  // Assert z when x is '1' and we are in state S2
        end
    endcase
end

endmodule