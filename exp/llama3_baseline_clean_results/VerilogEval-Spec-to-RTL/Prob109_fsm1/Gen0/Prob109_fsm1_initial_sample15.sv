module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Current state (0 - A, 1 - B)
reg [0:0] next_state; // Next state
reg [0:0] output; // Output

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        1'b0: begin // State A
            case (in)
                1'b0: next_state = 1; // A -> B on input 0
                1'b1: next_state = 0; // A -> A on input 1
            endcase
            output = 1'b0; // Output 0 in state A
        end
        1'b1: begin // State B
            case (in)
                1'b0: next_state = 0; // B -> A on input 0
                1'b1: next_state = 1; // B -> B on input 1
            endcase
            output = 1'b1; // Output 1 in state B
        end
    endcase
end

assign out = output;

endmodule