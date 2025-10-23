module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // synchronous active-low reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding: how many bits matched of "1001"
    localparam IDLE = 2'd0,
               S1   = 2'd1,    // matched '1'
               S10  = 2'd2,    // matched "10"
               S100 = 2'd3;    // matched "100"

    reg [1:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = data_in ? S1 : IDLE;
            S1:    next_state = data_in ? S1 : S10;
            S10:   next_state = data_in ? S1 : S100;
            S100:  next_state = data_in ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected is asserted one clock cycle when sequence "1001" detected
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S100) && data_in;
    end

endmodule