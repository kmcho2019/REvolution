module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding
    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;
    localparam S3 = 3'b011;
    localparam S4 = 3'b100;

    reg [2:0] state, next_state;

    // Function to compute next state based on current state and input
    function [2:0] get_next_state;
        input [2:0] curr_state;
        input       in_bit;
        begin
            case (curr_state)
                S0: get_next_state = in_bit ? S1 : S0;
                S1: get_next_state = in_bit ? S2 : S0;
                S2: get_next_state = in_bit ? S2 : S3;
                S3: get_next_state = in_bit ? S4 : S0;
                S4: get_next_state = S4; // sticky final state
                default: get_next_state = S0;
            endcase
        end
    endfunction

    // Combinational next state assignment using the function
    always @(*) begin
        next_state = get_next_state(state, data);
    end

    // Synchronous state update with active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output combinationally driven from state
    assign start_shifting = (state == S4);

endmodule