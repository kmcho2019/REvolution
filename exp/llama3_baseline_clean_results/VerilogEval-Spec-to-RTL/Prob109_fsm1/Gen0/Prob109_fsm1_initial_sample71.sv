module TopModule(
    input       clk,
    input       areset,
    input       in,
    output      out
);

reg [0:0] current_state; // 0 for A, 1 for B
reg [0:0] next_state;

// Asynchronous reset to state B (1)
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b1; // Reset to state B
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic to determine next state
always @(*) begin
    case(current_state)
        1'b0: // State A
            case(in)
                1'b0: next_state = 1'b1; // A(0) --0--> B
                1'b1: next_state = 1'b0; // A(0) --1--> A
                default: next_state = 1'b0;
            endcase
        1'b1: // State B
            case(in)
                1'b0: next_state = 1'b0; // B(1) --0--> A
                1'b1: next_state = 1'b1; // B(1) --1--> B
                default: next_state = 1'b1;
            endcase
        default: next_state = 1'b1; // Default to state B if current state is unknown
    endcase
end

// Output logic
assign out = current_state;

endmodule