module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    localparam IDLE = 3'b000,
               S1   = 3'b001,
               S2   = 3'b010,
               S3   = 3'b011;

    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1   : IDLE;
            S1:   next_state = data_in ? S1   : S2;
            S2:   next_state = data_in ? S1   : S3;
            S3:   next_state = data_in ? S1   : IDLE;  // Detect "1001" when in S3 and data_in=1
            default: next_state = IDLE;
        endcase
    end

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic: sequence_detected asserted synchronously when in S3 and data_in is '1'
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S3) && (data_in == 1'b1);
    end

endmodule