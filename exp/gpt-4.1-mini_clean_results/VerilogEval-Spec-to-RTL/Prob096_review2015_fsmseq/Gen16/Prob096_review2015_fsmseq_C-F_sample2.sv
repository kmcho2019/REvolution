module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output wire start_shifting
);

    // State encoding using localparam for readability and maintainability
    localparam [2:0]
        S0 = 3'b000, // No bits matched yet
        S1 = 3'b001, // Matched '1'
        S2 = 3'b010, // Matched "11"
        S3 = 3'b011, // Matched "110"
        S4 = 3'b100; // Matched "1101" - final detected sticky state

    reg [2:0] state, next_state;

    // Sequential logic: state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational logic: next state logic implementing sequence detection with sticky final state
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4; // Hold final detected state indefinitely
            default: next_state = S0;
        endcase
    end

    // Output logic: assert start_shifting when in the final detected state
    assign start_shifting = (state == S4);

endmodule