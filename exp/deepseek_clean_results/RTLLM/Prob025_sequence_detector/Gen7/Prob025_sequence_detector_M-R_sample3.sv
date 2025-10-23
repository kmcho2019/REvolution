module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

    // State encoding
    reg [1:0] state, next_state;
    localparam S0 = 2'b00,
               S1 = 2'b01,
               S2 = 2'b10,
               S3 = 2'b11;

    // State transition logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = data_in ? S1 : S0;
            S1: next_state = data_in ? S1 : S2;
            S2: next_state = data_in ? S3 : S0;
            S3: next_state = data_in ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // Output logic (Mealy style)
    assign sequence_detected = (state == S3) && !data_in;

endmodule