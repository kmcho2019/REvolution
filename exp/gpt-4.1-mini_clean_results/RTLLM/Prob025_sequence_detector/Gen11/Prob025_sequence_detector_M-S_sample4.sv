module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // active low asynchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    localparam IDLE = 3'd0;
    localparam S1   = 3'd1;
    localparam S2   = 3'd2;
    localparam S3   = 3'd3;
    localparam S4   = 3'd4;

    reg [2:0] state, next_state;

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:   next_state = (data_in == 1'b1) ? S1   : IDLE;
            S1:     next_state = (data_in == 1'b0) ? S2   : S1;
            S2:     next_state = (data_in == 1'b0) ? S3   : IDLE;
            S3:     next_state = (data_in == 1'b1) ? S4   : IDLE;
            S4:     next_state = (data_in == 1'b1) ? S1   : IDLE; // allow overlapping
            default: next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected asserted for one cycle when entering S4
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S3) && (data_in == 1'b1);
    end

endmodule