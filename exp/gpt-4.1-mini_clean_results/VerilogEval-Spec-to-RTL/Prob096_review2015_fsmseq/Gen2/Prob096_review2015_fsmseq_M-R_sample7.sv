module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding
    localparam S0 = 3'b000; // no match yet
    localparam S1 = 3'b001; // matched '1'
    localparam S2 = 3'b010; // matched '11'
    localparam S3 = 3'b011; // matched '110'
    localparam S4 = 3'b100; // matched '1101' (final state)

    reg [2:0] state;

    // Function to compute next state
    function [2:0] next_state_fn;
        input [2:0] curr_state;
        input bit_in;
        begin
            case (curr_state)
                S0: next_state_fn = bit_in ? S1 : S0;
                S1: next_state_fn = bit_in ? S2 : S0;
                S2: next_state_fn = (bit_in == 1'b0) ? S3 : S2;
                S3: next_state_fn = bit_in ? S4 : S0;
                S4: next_state_fn = S4;
                default: next_state_fn = S0;
            endcase
        end
    endfunction

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state_fn(state, data);
    end

    // Output logic: combinational and purely from state
    assign start_shifting = (state == S4);

endmodule