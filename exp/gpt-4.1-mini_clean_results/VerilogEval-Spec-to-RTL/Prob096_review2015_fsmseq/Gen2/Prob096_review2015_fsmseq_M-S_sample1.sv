module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding: 2 bits sufficient for tracking sequence progress
    localparam S0 = 2'b00; // no match
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched '11'
    localparam S3 = 2'b11; // matched '110'

    reg [1:0] state, next_state;
    reg found; // sticky flag indicating sequence found

    // Next state logic
    always @(*) begin
        case(state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state and found flag update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            found <= 1'b0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Detect sequence completion when transitioning from S3 with data=1 (pattern "1101")
            if (~found && (state == S3) && data)
                found <= 1'b1;
            start_shifting <= found || ((state == S3) && data);
        end
    end

endmodule