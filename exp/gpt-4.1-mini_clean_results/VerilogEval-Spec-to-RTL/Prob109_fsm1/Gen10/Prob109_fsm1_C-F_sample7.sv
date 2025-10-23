module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Next-state combinational logic as a function
    function automatic [0:0] next_state_func;
        input current_state, input_in;
        begin
            case (current_state)
                B: next_state_func = (input_in == 1'b0) ? A : B;
                A: next_state_func = (input_in == 1'b0) ? B : A;
                default: next_state_func = B;
            endcase
        end
    endfunction

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state_func(state, in);
    end

    // Moore output depends only on state
    always @(*) begin
        case(state)
            A: out = 1'b0;
            B: out = 1'b1;
            default: out = 1'b1;
        endcase
    end

endmodule