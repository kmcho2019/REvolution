module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot state encoding: state[1] = B, state[0] = A
    reg [1:0] state;

    // Asynchronous active-high reset and state register update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // Reset to state A
        else begin
            case (state)
                2'b01: state <= x ? 2'b10 : 2'b01; // A -> B if x=1 else stay A
                2'b10: state <= 2'b10;             // B stays B
                default: state <= 2'b01;           // Default to A on invalid state
            endcase
        end
    end

    // Mealy output combinational logic
    assign z = (state[0] & x) | (state[1] & ~x);

endmodule