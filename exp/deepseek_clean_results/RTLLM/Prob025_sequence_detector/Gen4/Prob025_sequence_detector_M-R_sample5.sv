module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

    // One-hot encoded states
    localparam [4:0] IDLE = 5'b00001,
                     S1   = 5'b00010,
                     S2   = 5'b00100,
                     S3   = 5'b01000,
                     S4   = 5'b10000;

    reg [4:0] current_state, next_state;

    // State register
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : S2;
            default: next_state = IDLE;
        endcase
    end

    // Output logic (combinational)
    assign sequence_detected = (current_state == S4);

endmodule