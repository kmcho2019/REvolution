module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot state encoding using 5-bit vector
    localparam S0 = 5'b00001; // no match
    localparam S1 = 5'b00010; // matched '1'
    localparam S2 = 5'b00100; // matched '11'
    localparam S3 = 5'b01000; // matched '110'
    localparam S4 = 5'b10000; // matched '1101' final sticky

    reg [4:0] state;

    // Function to compute next state based on current state and input data
    function [4:0] next_state_func;
        input [4:0] curr_state;
        input       bit_in;
        begin
            case (curr_state)
                S0: next_state_func = bit_in ? S1 : S0;
                S1: next_state_func = bit_in ? S2 : S0;
                S2: next_state_func = bit_in ? S2 : S3;
                S3: next_state_func = bit_in ? S4 : S0;
                S4: next_state_func = S4; // sticky final state
                default: next_state_func = S0;
            endcase
        end
    endfunction

    // Sequential logic: synchronous reset, update state every clock cycle
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state_func(state, data);
    end

    // Output combinational: asserted when in final sticky state
    assign start_shifting = (state == S4);

endmodule