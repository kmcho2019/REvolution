module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // 1-bit state register
reg [0:0] nextState; // 1-bit next state register

// State encoding: 0 - A, 1 - B

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        1'b0: begin // State A
            if (in == 1'b0) begin
                nextState = 1'b1; // A -> B
                out = 1'b0; // Output in state A
            end else begin
                nextState = 1'b0; // A -> A
                out = 1'b0; // Output in state A
            end
        end
        1'b1: begin // State B
            if (in == 1'b0) begin
                nextState = 1'b0; // B -> A
                out = 1'b1; // Output in state B
            end else begin
                nextState = 1'b1; // B -> B
                out = 1'b1; // Output in state B
            end
        end
    endcase
end

endmodule