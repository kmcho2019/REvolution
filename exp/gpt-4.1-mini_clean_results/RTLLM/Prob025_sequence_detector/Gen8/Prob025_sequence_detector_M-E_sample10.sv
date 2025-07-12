module sequence_detector (
    input  wire clk,
    input  wire reset_n,         // active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (binary)
    localparam [2:0]
        IDLE = 3'b000,
        S1   = 3'b001,
        S2   = 3'b010,
        S3   = 3'b011,
        S4   = 3'b100;

    reg [2:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: next_state = (data_in) ? S1 : IDLE;
            S1:   next_state = (data_in) ? S1 : S2;       // Expect 0 after first 1
            S2:   next_state = (!data_in) ? S3 : IDLE;    // Expect 0 after 10
            S3:   next_state = (data_in) ? S4 : IDLE;     // Expect 1 after 100
            S4:   next_state = (data_in) ? S1 : IDLE;     // After detected, check for overlap
            default: next_state = IDLE;
        endcase
    end

    // Output logic: Moore machine output, asserted only in S4 state
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule