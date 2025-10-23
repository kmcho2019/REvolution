module sequence_detector (
    input clk,
    input reset_n,  // Consistent naming
    input data_in,
    output reg sequence_detected
);

    // One-hot state encoding for better timing
    localparam [3:0] IDLE = 4'b0001,
                     S1   = 4'b0010,  // '1'
                     S2   = 4'b0100,  // '10'
                     S3   = 4'b1000;  // '100'

    reg [3:0] state, next_state;

    // State transition (sequential logic)
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = IDLE;  // Default
        case (1'b1)  // Synopsys parallel_case
            state[0]: next_state = data_in ? S1 : IDLE;  // IDLE
            state[1]: next_state = data_in ? S1 : S2;    // S1
            state[2]: next_state = data_in ? S3 : IDLE;  // S2
            state[3]: next_state = data_in ? S1 : IDLE;  // S3
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        sequence_detected = (state == S3) && data_in;
    end

endmodule