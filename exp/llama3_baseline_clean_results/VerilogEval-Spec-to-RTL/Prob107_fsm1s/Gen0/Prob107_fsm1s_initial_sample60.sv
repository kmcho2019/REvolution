module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states
parameter B = 1'b0, A = 1'b1;

// Internal state variable
reg current_state;

// Output logic
assign out = (current_state == B) ? 1'b1 : 1'b0;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        // Reset to state B on active-high reset
        current_state <= B;
    end else begin
        case (current_state)
            B: begin
                if (!in) begin
                    current_state <= A;
                end else begin
                    current_state <= B;
                end
            end
            A: begin
                if (!in) begin
                    current_state <= B;
                end else begin
                    current_state <= A;
                end
            end
            default: begin
                current_state <= B; // Default to B if current state is undefined
            end
        endcase
    end
end

endmodule