module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Using a reg for the state
parameter B = 1'b1, A = 1'b0; // Parameters for states B and A

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B; // Reset state to B when areset is high
    end else begin
        case (state)
            B: begin
                if (in == 1'b1) begin
                    state <= B; // Stay in B when in is 1
                end else begin
                    state <= A; // Move to A when in is 0
                end
            end
            A: begin
                if (in == 1'b1) begin
                    state <= A; // Stay in A when in is 1
                end else begin
                    state <= B; // Move to B when in is 0
                end
            end
            default: state <= B; // Default to state B
        endcase
    end
end

always @(*) begin
    case (state)
        B: out = 1'b1; // Output is 1 when state is B
        A: out = 1'b0; // Output is 0 when state is A
        default: out = 1'b1; // Default output to 1
    endcase
end

endmodule