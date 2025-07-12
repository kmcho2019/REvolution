module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // State encoding
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state;

    // Function to determine next state
    function [1:0] next_state_func;
        input [1:0] curr_state;
        input       in_bit;
        begin
            case (curr_state)
                A: next_state_func = (in_bit == 1'b0) ? A : B;
                B: next_state_func = (in_bit == 1'b0) ? C : B;
                C: next_state_func = (in_bit == 1'b0) ? A : D;
                D: next_state_func = (in_bit == 1'b0) ? C : B;
                default: next_state_func = A;
            endcase
        end
    endfunction

    wire [1:0] next_state;
    assign next_state = next_state_func(state, in);

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Registered output to reflect Moore FSM output (depends on state)
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;
        else
            out <= (state == D);
    end

endmodule