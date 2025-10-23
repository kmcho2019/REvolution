module TopModule(
    input clk,
    input a,
    output reg q
);

reg [0:0] state; // 0: low, 1: high

// Initialize state to high (q = 1)
initial state = 1;

// At each positive clock edge, update state
always @(posedge clk) begin
    case (state)
        1'b1: // high state
            if (a == 1'b1) begin
                state <= 1'b0; // transition to low state
            end else begin
                state <= 1'b1; // remain in high state
            end
        1'b0: // low state
            state <= 1'b0; // remain in low state
    endcase
end

// Assign q based on the current state
always @(state) begin
    case (state)
        1'b1: q <= 1'b1;
        1'b0: q <= 1'b0;
    endcase
end

endmodule