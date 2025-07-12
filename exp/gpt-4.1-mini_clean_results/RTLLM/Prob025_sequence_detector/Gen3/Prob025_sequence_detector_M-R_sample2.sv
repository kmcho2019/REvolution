module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // active low synchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding
    localparam IDLE = 3'd0;
    localparam S1   = 3'd1;
    localparam S2   = 3'd2;
    localparam S3   = 3'd3;

    reg [2:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state and output logic (Mealy FSM)
    reg detected;
    always @(*) begin
        detected = 1'b0;
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (~data_in)
                    next_state = S2;
                else
                    next_state = S1;
            end

            S2: begin
                if (~data_in)
                    next_state = S3;
                else
                    next_state = S1;
            end

            S3: begin
                if (data_in) begin
                    next_state = S1;
                    detected = 1'b1;  // sequence "1001" detected here
                end else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    assign sequence_detected = detected;

endmodule