module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding: only essential states to detect 1101
    localparam S0 = 2'b00; // no match yet
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched '11' or '110'
    localparam S3 = 2'b11; // matched '1101' final sticky state

    reg [1:0] state, next_state;

    always @(*) begin
        case(state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3; // data=0 moves toward final if sequence matches
            S3: next_state = S3; // sticky final state
            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    assign start_shifting = (state == S3);

endmodule