module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding
    localparam S0 = 3'd0; // no match
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched "11"
    localparam S3 = 3'd3; // matched "110"

    reg [2:0] state, next_state;

    // Synchronous state update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Set start_shifting high on detecting "1101"
            if (state == S3 && data)
                start_shifting <= 1'b1;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S1 : S0;
            default: next_state = S0;
        endcase
    end

endmodule