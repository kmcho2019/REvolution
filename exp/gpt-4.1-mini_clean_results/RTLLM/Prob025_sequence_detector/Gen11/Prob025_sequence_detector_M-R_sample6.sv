module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // Active-low synchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // One-hot state encoding: 5 states
    localparam IDLE = 5'b00001;
    localparam S1   = 5'b00010; // matched '1'
    localparam S2   = 5'b00100; // matched '10'
    localparam S3   = 5'b01000; // matched '100'
    localparam S4   = 5'b10000; // matched '1001'

    reg [4:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
            S1:   next_state = (data_in == 1'b0) ? S2 : S1;
            S2:   next_state = (data_in == 1'b0) ? S3 : IDLE;
            S3:   next_state = (data_in == 1'b1) ? S4 : S2;
            S4:   next_state = (data_in == 1'b1) ? S1 : S2;
            default: next_state = IDLE;
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic: sequence_detected asserted when in S4 state
    assign sequence_detected = (state == S4);

endmodule