module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // Binary encoded states
    localparam [2:0]
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '11'
        S3 = 3'd3, // matched '110'
        S4 = 3'd4; // matched '1101' final sticky

    reg [2:0] state, next_state;
    reg start_shifting_reg;

    // Combinational function for next state based on current state and input data
    function [2:0] get_next_state;
        input [2:0] cur_state;
        input       bit_in;
        begin
            case (cur_state)
                S0: get_next_state = bit_in ? S1 : S0;
                S1: get_next_state = bit_in ? S2 : S0;
                S2: get_next_state = bit_in ? S2 : S3;
                S3: get_next_state = bit_in ? S4 : S0;
                S4: get_next_state = S4;
                default: get_next_state = S0;
            endcase
        end
    endfunction

    // Combinational assignment for next_state
    always @(*) begin
        next_state = get_next_state(state, data);
    end

    // Sequential logic: state update and output register update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting_reg <= 1'b0;
        end else begin
            state <= next_state;
            // Output sticky once state S4 is reached
            if (next_state == S4)
                start_shifting_reg <= 1'b1;
        end
    end

    assign start_shifting = start_shifting_reg;

endmodule