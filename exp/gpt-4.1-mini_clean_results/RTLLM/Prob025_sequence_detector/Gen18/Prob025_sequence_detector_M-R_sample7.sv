module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // active low synchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding (binary)
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001,
        S2   = 3'b010,
        S3   = 3'b011,
        S4   = 3'b100
    } state_t;

    state_t state, next_state;

    // Next state logic - combinational using assign
    wire [2:0] next_state_comb;

    assign next_state_comb = (state == IDLE) ? (data_in ? S1 : IDLE) :
                             (state == S1)   ? (data_in == 1'b0 ? S2 : S1) :
                             (state == S2)   ? (data_in == 1'b0 ? S3 : S1) :
                             (state == S3)   ? (data_in ? S4 : IDLE) :
                             (state == S4)   ? (data_in ? S1 : IDLE) :
                             IDLE;

    // State register update with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state_comb;
    end

    // Output combinational logic: sequence_detected is high when in S4 state
    assign sequence_detected = (state == S4);

endmodule