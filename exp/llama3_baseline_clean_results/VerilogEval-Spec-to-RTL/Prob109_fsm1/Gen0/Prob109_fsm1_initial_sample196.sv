module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] current_state; // Using 1-bit to represent states A and B
reg [0:0] next_state;

// State encoding: A = 0, B = 1
// Output logic: out = current_state

always @(areset or current_state or in) begin
    case(current_state)
        0: // State A
            if (in == 1'b1)
                next_state = 0; // A (0) --1--> A
            else
                next_state = 1; // A (0) --0--> B
        1: // State B
            if (in == 1'b1)
                next_state = 1; // B (1) --1--> B
            else
                next_state = 0; // B (1) --0--> A
        default:
            next_state = 1'b1; // Default to state B if current state is unknown
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b1; // Asynchronously reset to state B
    end else begin
        current_state <= next_state;
    end
end

assign out = current_state; // Since out depends directly on the state

endmodule