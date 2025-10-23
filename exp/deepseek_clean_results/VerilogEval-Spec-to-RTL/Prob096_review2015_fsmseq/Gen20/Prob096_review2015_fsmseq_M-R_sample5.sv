module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding
    localparam S0 = 2'b00; // Initial state
    localparam S1 = 2'b01; // Received '1'
    localparam S2 = 2'b10; // Received '11'
    localparam S3 = 2'b11; // Received '110'

    reg [1:0] state, next_state;
    reg found;

    // Combinational next state logic
    always @(*) begin
        if (found) begin
            next_state = state; // Freeze state after detection
        end else begin
            case (state)
                S0: next_state = data ? S1 : S0;
                S1: next_state = data ? S2 : S0;
                S2: next_state = data ? S2 : S3;
                S3: next_state = data ? S1 : S0;
                default: next_state = S0;
            endcase
        end
    end

    // Sequential state update and detection logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            found <= 1'b0;
        end else begin
            state <= next_state;
            // Detect when we're in S3 and get a '1' (completing 1101)
            if (state == S3 && data && !found)
                found <= 1'b1;
        end
    end

    assign start_shifting = found;

endmodule