module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (2-bit for 4 states)
    localparam IDLE = 2'b00,
               S1   = 2'b01,
               S2   = 2'b10,
               S3   = 2'b11;

    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic for sequence "1001"
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic: assert sequence_detected when sequence "1001" detected
    // Occurs when current state is S3 and data_in == 1 (completes "1001")
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S3) && (data_in == 1'b1);
    end

endmodule