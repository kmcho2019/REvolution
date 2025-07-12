module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding
    localparam S0 = 1'b0; // Waiting for first '1'
    localparam S1 = 1'b1; // Inverting subsequent bits

    reg state;
    reg x_reg;

    // Sequential logic: state and input capture with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            x_reg <= 1'b0;
        end else begin
            state <= next_state(state, x_reg);
            x_reg <= x;
        end
    end

    // Next state logic implemented as a function
    function automatic [0:0] next_state(input [0:0] curr_state, input curr_x);
        case (curr_state)
            S0: next_state = (curr_x == 1'b1) ? S1 : S0;
            S1: next_state = S1;
            default: next_state = S0;
        endcase
    endfunction

    // Moore output depends only on registered state and x_reg
    assign z = (state == S0) ? x_reg : ~x_reg;

endmodule