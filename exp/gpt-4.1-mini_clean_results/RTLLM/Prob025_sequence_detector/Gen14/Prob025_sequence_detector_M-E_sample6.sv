module sequence_detector (
    input  wire clk,
    input  wire reset_n,        // active low synchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // One-hot state encoding: 5 states
    localparam IDLE = 5'b00001;
    localparam S1   = 5'b00010;  // matched '1'
    localparam S2   = 5'b00100;  // matched '10'
    localparam S3   = 5'b01000;  // matched '100'
    localparam S4   = 5'b10000;  // matched '1001' (final detection)

    reg [4:0] state, next_state;

    // Next state logic combinational block
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (~data_in)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                if (~data_in)
                    next_state = S3;
                else
                    next_state = S1;
            end
            S3: begin
                if (data_in)
                    next_state = S4;
                else
                    next_state = IDLE;
            end
            S4: begin
                // After detection, restart with overlap detection
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register with synchronous active low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output combinational logic (Mealy output) asserted when next input completes sequence
    // The sequence "1001" is detected when current state is S3 and data_in=1 arrives
    // Alternatively, also detect when state is S4 (the detection state) just for completeness
    assign sequence_detected = (state == S3) && data_in;

endmodule