module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // active low synchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // Binary encoded FSM states using localparams
    localparam IDLE = 3'd0;
    localparam S1   = 3'd1;
    localparam S2   = 3'd2;
    localparam S3   = 3'd3;

    reg [2:0] state, next_state;

    // Next state combinational logic
    wire next_s1, next_s2, next_s3;

    assign next_state = 
        (state == IDLE) ? (data_in ? S1 : IDLE) :
        (state == S1)   ? (~data_in ? S2 : S1) :
        (state == S2)   ? (~data_in ? S3 : S1) :
        (state == S3)   ? (data_in ? S1 : IDLE) :
                         IDLE;

    // Mealy output logic: sequence_detected asserted when FSM at S3 and data_in=1 completes '1001'
    assign sequence_detected = (state == S3) && data_in;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

endmodule