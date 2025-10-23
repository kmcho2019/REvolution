module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot encoding for states
    localparam B = 2'b01;
    localparam A = 2'b10;

    reg [1:0] state, next_state;

    // Combinational logic for next state
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B; // safe default to reset state
        endcase
    end

    // Synchronous state update with active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    // Moore output: 1 when in B state, else 0
    assign out = state[0];

endmodule