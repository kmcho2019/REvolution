module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output wire start_shifting
);

    // State encoding (3-bit binary) for clarity and minimal area
    localparam [2:0]
        S0 = 3'd0, // no bits matched yet
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched "11"
        S3 = 3'd3, // matched "110"
        S4 = 3'd4; // matched "1101" (sticky final state)

    reg [2:0] state, next_state;
    wire      ce; // clock enable to freeze state in final detected state

    // Next state combinational logic - clean and explicit case statement
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4; // sticky final state, hold here
            default: next_state = S0;
        endcase
    end

    // Clock enable active when not in sticky final state
    assign ce = (state != S4);

    // State register update: synchronous reset and clock enable to reduce toggling
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else if (ce)
            state <= next_state;
    end

    // Moore output: combinationally derived from current state
    assign start_shifting = (state == S4);

endmodule