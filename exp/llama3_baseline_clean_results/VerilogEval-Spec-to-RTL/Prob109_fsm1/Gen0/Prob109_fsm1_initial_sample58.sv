module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Using a single bit to represent two states
parameter A = 1'b0;
parameter B = 1'b1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronously reset to state B
        state <= B;
    end else begin
        case (state)
            A: begin
                if (in) begin
                    state <= A; // State A to A on in = 1
                end else begin
                    state <= B; // State A to B on in = 0
                end
            end
            B: begin
                if (in) begin
                    state <= B; // State B to B on in = 1
                end else begin
                    state <= A; // State B to A on in = 0
                end
            end
            default: state <= B; // Default state
        endcase
    end
end

// Out is determined by the state
assign out = (state == B) ? 1'b1 : 1'b0;

endmodule