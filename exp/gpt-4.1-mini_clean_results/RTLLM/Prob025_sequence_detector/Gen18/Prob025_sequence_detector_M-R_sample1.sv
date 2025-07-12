module sequence_detector (
    input  wire clk,
    input  wire reset_n,         // Active-low synchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding (2 bits)
    localparam IDLE = 2'd0,
               S1   = 2'd1,
               S2   = 2'd2,
               S3   = 2'd3;

    reg [1:0] state, next_state;

    // Next-state and output logic (Mealy FSM)
    reg seq_detected_comb;

    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
                seq_detected_comb = 1'b0;
            end
            S1: begin
                if (!data_in)
                    next_state = S2;
                else
                    next_state = S1;
                seq_detected_comb = 1'b0;
            end
            S2: begin
                if (!data_in)
                    next_state = S3;
                else
                    next_state = S1;
                seq_detected_comb = 1'b0;
            end
            S3: begin
                if (data_in) begin
                    next_state = S1;
                    seq_detected_comb = 1'b1;   // Sequence "1001" detected here
                end else begin
                    next_state = IDLE;
                    seq_detected_comb = 1'b0;
                end
            end
            default: begin
                next_state = IDLE;
                seq_detected_comb = 1'b0;
            end
        endcase
    end

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output is combinational Mealy output
    assign sequence_detected = seq_detected_comb;

endmodule