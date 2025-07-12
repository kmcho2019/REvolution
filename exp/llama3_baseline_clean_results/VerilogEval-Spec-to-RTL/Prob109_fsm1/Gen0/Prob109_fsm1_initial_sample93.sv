module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] state; // 0 represents state A, 1 represents state B
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // Asynchronously reset into state B
    end else begin
        case (state)
            0: begin // State A
                if (in == 0) begin
                    state <= 1; // Transition to state B on in = 0
                end else begin
                    state <= 0; // Stay in state A on in = 1
                end
            end
            1: begin // State B
                if (in == 0) begin
                    state <= 0; // Transition to state A on in = 0
                end else begin
                    state <= 1; // Stay in state B on in = 1
                end
            end
        endcase
    end
end

always @(state) begin
    out <= state; // Output is 1 when in state B, 0 when in state A
end

endmodule