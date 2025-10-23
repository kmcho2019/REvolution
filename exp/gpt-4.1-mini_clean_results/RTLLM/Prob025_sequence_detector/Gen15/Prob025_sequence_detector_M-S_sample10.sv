module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding: number of matched bits so far
    localparam S0 = 2'd0, // No bits matched
               S1 = 2'd1, // matched '1'
               S2 = 2'd2, // matched '10'
               S3 = 2'd3; // matched '100'

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            S0: next_state = data_in ? S1 : S0;          // Waiting for first '1'
            S1: next_state = data_in ? S1 : S2;          // '1' followed by '0'
            S2: next_state = data_in ? S3 : S0;          // '10' followed by '0' or '1'
            S3: next_state = data_in ? S1 : S2;          // '100' followed by '1' (detected) or '0'
            default: next_state = S0;
        endcase
    end

    // State and output register
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= S0;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Output asserted when sequence '1001' is detected on input bit that leads from S3 to S1
            sequence_detected <= (state == S3) && data_in;
        end
    end

endmodule