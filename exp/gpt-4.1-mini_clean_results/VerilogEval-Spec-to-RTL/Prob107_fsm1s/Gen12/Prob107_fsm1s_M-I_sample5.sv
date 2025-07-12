module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot encoding for states
    localparam B = 2'b01;
    localparam A = 2'b10;

    reg [1:0] state, next_state;

    // Generate enable to clock gate the state register only when a transition occurs
    wire state_changing;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    assign state_changing = (next_state != state);

    // State register with clock enable for reduced power toggling
    reg gated_clk;
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else if (state_changing) begin
            state <= next_state;
        end
    end

    // Moore output depends on state B or A
    // Output = 1 if in state B (encoded as 2'b01)
    assign out = state[0];

endmodule