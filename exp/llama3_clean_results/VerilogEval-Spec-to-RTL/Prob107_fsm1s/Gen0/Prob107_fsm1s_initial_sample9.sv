module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // Using 2 bits to represent two states
parameter B = 2'b01; // Representing state B
parameter A = 2'b10; // Representing state A

always @(posedge clk) begin
    if (reset) begin
        state <= B;
        out <= 1'b1; // Reset output when in state B
    end else begin
        case (state)
            B: begin
                if (in == 1'b0) begin
                    state <= A;
                    out <= 1'b0; // Output when in state A
                end else begin
                    state <= B;
                    out <= 1'b1; // Output when in state B
                end
            end
            A: begin
                if (in == 1'b0) begin
                    state <= B;
                    out <= 1'b1; // Output when in state B
                end else begin
                    state <= A;
                    out <= 1'b0; // Output when in state A
                end
            end
            default: state <= B; // Default state
        endcase
    end
end

initial begin
    state <= B; // Initialize state
    out <= 1'b1; // Initialize output
end

endmodule