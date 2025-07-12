module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding using localparams for clarity
    localparam S0 = 3'd0; // no match
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched "11"
    localparam S3 = 3'd3; // matched "110"
    localparam S4 = 3'd4; // matched "1101" (final)

    reg [2:0] state, next_state;

    // Function to compute next state
    function [2:0] calc_next_state(input [2:0] curr_state, input data_in);
        begin
            case (curr_state)
                S0: calc_next_state = data_in ? S1 : S0;
                S1: calc_next_state = data_in ? S2 : S0;
                S2: calc_next_state = data_in ? S2 : S3;
                S3: calc_next_state = data_in ? S4 : S0;
                S4: calc_next_state = S4;
                default: calc_next_state = S0;
            endcase
        end
    endfunction

    // State register and output register update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == S4)
                start_shifting <= 1'b1;
        end
    end

    // Combinational logic to determine next state
    always @(*) begin
        next_state = calc_next_state(state, data);
    end

endmodule