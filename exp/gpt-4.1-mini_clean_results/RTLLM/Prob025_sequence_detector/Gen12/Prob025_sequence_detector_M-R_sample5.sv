module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // synchronous active-low reset
    input  wire data_in,
    output wire sequence_detected
);

    // Binary-encoded states (3 bits suffice for 5 states)
    localparam IDLE = 3'd0,
               S1   = 3'd1,
               S2   = 3'd2,
               S3   = 3'd3,
               S4   = 3'd4;

    reg [2:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = (data_in == 1'b1) ? S1 : IDLE;
            S1:    next_state = (data_in == 1'b0) ? S2 : S1;
            S2:    next_state = (data_in == 1'b0) ? S3 : IDLE;
            S3:    next_state = (data_in == 1'b1) ? S4 : IDLE;
            S4:    next_state = (data_in == 1'b1) ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic: Moore machine output asserted for one clock cycle in S4 state
    assign sequence_detected = (state == S4);

endmodule