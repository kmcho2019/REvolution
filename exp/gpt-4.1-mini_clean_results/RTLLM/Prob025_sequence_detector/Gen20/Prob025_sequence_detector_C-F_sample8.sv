module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low synchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding (3-bit binary)
    localparam IDLE = 3'b000,
               S1   = 3'b001,   // After detecting '1'
               S2   = 3'b010,   // After detecting '10'
               S3   = 3'b011;   // After detecting '100'

    reg [2:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic - minimal, combinational
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S1 : IDLE;  // sequence "1001" detected if data_in == 1 here
            default: next_state = IDLE;
        endcase
    end

    // Combinational output logic - assert when sequence detected (Moore style output)
    assign sequence_detected = (state == S3) && (data_in == 1'b1);

endmodule