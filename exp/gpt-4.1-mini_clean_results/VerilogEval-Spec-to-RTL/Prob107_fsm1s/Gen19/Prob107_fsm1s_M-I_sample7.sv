module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // One-hot encoding for two states
    localparam B = 2'b01;
    localparam A = 2'b10;

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Output register (Moore output)
    // out=1 when state is B, else 0
    always @(posedge clk) begin
        if (reset)
            out <= 1'b1;  // B state's output
        else
            out <= (state == B);
    end

endmodule