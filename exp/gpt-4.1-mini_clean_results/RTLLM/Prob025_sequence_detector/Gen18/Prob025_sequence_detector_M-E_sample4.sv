module sequence_detector (
    input  wire clk,
    input  wire reset,          // Active-high synchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding (2 bits)
    localparam S0 = 2'b00, // no bits matched
               S1 = 2'b01, // matched '1'
               S2 = 2'b10, // matched '10'
               S3 = 2'b11; // matched '100'

    reg [1:0] state, next_state;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            S0: next_state = (data_in) ? S1 : S0;            // Wait for first '1'
            S1: next_state = (data_in) ? S1 : S2;            // matched '1', expect '0'
            S2: next_state = (data_in) ? S1 : S3;            // matched '10', expect '0'
            S3: next_state = (data_in) ? S1 : S0;            // matched '100', expect '1' for sequence detect or else restart
            default: next_state = S0;
        endcase
    end

    // Output logic (Mealy): Assert when current state is S3 and data_in == 1, which completes "1001"
    assign sequence_detected = (state == S3) && data_in;

    // Sequential state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule