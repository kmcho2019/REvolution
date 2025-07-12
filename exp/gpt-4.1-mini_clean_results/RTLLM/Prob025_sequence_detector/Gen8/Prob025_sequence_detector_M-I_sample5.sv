module sequence_detector (
    input  wire clk,
    input  wire reset_n,         // Active-low asynchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // One-hot encoded states
    localparam [4:0] 
        IDLE = 5'b00001,
        S1   = 5'b00010,  // matched '1'
        S2   = 5'b00100,  // matched '10'
        S3   = 5'b01000,  // matched '100'
        S4   = 5'b10000;  // matched '1001' - detection complete

    reg [4:0] state, next_state;

    // Sequential logic with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : S2;  // Allow overlapping detection
            default: next_state = IDLE;
        endcase
    end

    // Output combinational: sequence detected only in S4
    assign sequence_detected = (state == S4);

endmodule