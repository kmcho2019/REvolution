module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

    // State encoding
    localparam [1:0] IDLE = 2'b00,
                     S1   = 2'b01,  // '1'
                     S2   = 2'b10,  // '10'
                     S3   = 2'b11;  // '100'

    reg [1:0] state, next_state;

    // State transition
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state and output logic
    always @(*) begin
        sequence_detected = 1'b0;
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S3 : IDLE;
            S3: begin
                sequence_detected = data_in;
                next_state = data_in ? S1 : IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule