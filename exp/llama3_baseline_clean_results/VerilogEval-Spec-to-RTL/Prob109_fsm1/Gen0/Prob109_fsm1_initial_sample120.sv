module TopModule(
    input           clk,
    input           areset,
    input           in,
    output reg      out
);

reg [0:0] state; // We only need 1 bit for two states

// Asynchronous reset into state B (state = 1)
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 1'b1; // Reset into state B
    end else begin
        case (state)
            1'b1: begin // State B
                if (in == 1'b1) begin
                    state <= 1'b1; // Stay in B if in is 1
                end else begin
                    state <= 1'b0; // Move to A if in is 0
                end
            end
            1'b0: begin // State A
                if (in == 1'b1) begin
                    state <= 1'b0; // Stay in A if in is 1
                end else begin
                    state <= 1'b1; // Move to B if in is 0
                end
            end
        endcase
    end
end

// Output determined by state (Moore machine)
always @(*) begin
    case (state)
        1'b1: out = 1'b1; // Output 1 when in state B
        1'b0: out = 1'b0; // Output 0 when in state A
    endcase
end

endmodule