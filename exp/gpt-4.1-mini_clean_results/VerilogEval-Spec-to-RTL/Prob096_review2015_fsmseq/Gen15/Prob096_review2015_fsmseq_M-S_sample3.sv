module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // Define FSM states
    localparam S0 = 3'd0; // no match
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '11'
    localparam S3 = 3'd3; // matched '110'

    reg [2:0] state, next_state;

    // Combinational next state logic using case statement
    always @(*) begin
        case(state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S1 : S0; // After matching 110, input=1 means 1101 matched
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state update and sticky output
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (state == S3 && data == 1'b1)
                start_shifting <= 1'b1;
        end
    end

endmodule