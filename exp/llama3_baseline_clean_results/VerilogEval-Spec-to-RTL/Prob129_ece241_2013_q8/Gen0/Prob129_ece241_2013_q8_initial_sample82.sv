module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define states
enum logic [1:0] {S0, S1, S2} state, next_state;

// Output logic
assign z = (state == S2) && x;

// Sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
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
            if (~x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x) begin
                next_state = S1; // Recognized "101", now looking for the next '1'
            end else begin
                next_state = S0; // Sequence not recognized, start over
            end
        end
    endcase
end

endmodule