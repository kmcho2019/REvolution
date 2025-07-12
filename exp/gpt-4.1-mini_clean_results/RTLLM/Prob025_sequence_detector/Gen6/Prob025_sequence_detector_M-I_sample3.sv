module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low asynchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot encoded states for FSM
    localparam IDLE = 4'b0001;    // No bits matched
    localparam S1   = 4'b0010;    // Matched '1'
    localparam S2   = 4'b0100;    // Matched "10"
    localparam S3   = 4'b1000;    // Matched "100"

    reg [3:0] state, next_state;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S3 : IDLE;
            S3:   next_state = data_in ? S1 : S2;
            default: next_state = IDLE;
        endcase
    end

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output register: asserted when sequence "1001" detected
    // The sequence is detected when current state is S3 and data_in == 1 (next input bit is '1').
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S3) && data_in;
    end

endmodule