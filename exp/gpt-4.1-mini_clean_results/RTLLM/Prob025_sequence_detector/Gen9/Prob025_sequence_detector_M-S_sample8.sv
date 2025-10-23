module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using parameters for compatibility
    parameter IDLE = 3'd0;
    parameter S1   = 3'd1;
    parameter S2   = 3'd2;
    parameter S3   = 3'd3;
    parameter S4   = 3'd4;

    reg [2:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (data_in == 1'b1) ? S1 : IDLE;
            S1:   next_state = (data_in == 1'b0) ? S2 : S1;
            S2:   next_state = (data_in == 1'b0) ? S3 : S1;
            S3:   next_state = (data_in == 1'b1) ? S4 : IDLE;
            S4:   next_state = (data_in == 1'b1) ? S1 : S2;
            default: next_state = IDLE;
        endcase
    end

    // Output logic: assert sequence_detected in state S4
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule