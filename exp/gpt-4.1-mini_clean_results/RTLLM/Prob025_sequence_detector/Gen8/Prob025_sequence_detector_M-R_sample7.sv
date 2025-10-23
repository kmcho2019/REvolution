module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // Active-low asynchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (binary)
    localparam [2:0]
        IDLE = 3'd0,
        S1   = 3'd1,   // matched '1'
        S2   = 3'd2,   // matched '10'
        S3   = 3'd3,   // matched '100'
        S4   = 3'd4;   // matched '1001' - detection complete

    reg [2:0] state, next_state;

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : S2; // allow overlapping sequences
            default: next_state = IDLE;
        endcase
    end

    // Output registered, asserted only in S4 state
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule