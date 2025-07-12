module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state; // 0 represents state A, 1 represents state B

// Output logic
assign out = state;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        case (state)
            1'b0: begin // State A
                if (in) begin
                    state <= 1'b0; // Stay in state A
                end else begin
                    state <= 1'b1; // Go to state B
                end
            end
            1'b1: begin // State B
                if (in) begin
                    state <= 1'b1; // Stay in state B
                end else begin
                    state <= 1'b0; // Go to state A
                end
            end
        endcase
    end
end

endmodule