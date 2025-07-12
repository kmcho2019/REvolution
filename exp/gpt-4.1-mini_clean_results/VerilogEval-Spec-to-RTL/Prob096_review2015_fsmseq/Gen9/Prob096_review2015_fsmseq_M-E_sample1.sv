module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding for detecting "1101"
    localparam S0 = 2'd0; // no match yet
    localparam S1 = 2'd1; // matched '1'
    localparam S2 = 2'd2; // matched '11'
    localparam S3 = 2'd3; // matched '110'

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S1 : S0; // If input=1, partial match of first '1'
            default: next_state = S0;
        endcase
    end

    // Sequential logic for state and output with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            // Update state
            state <= next_state;

            // Set start_shifting sticky if sequence detected:
            // Sequence '1101' detected when in S3 and input=1 (because transition from S3 to S1 on data=1 means sequence ends)
            if (start_shifting)
                start_shifting <= 1'b1; // remain asserted
            else if (state == S3 && data == 1'b1)
                start_shifting <= 1'b1;
            else
                start_shifting <= 1'b0;
        end
    end

endmodule