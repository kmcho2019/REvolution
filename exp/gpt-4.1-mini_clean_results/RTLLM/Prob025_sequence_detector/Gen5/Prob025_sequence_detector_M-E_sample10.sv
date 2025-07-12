module sequence_detector (
    input  wire clk,
    input  wire reset_n,         // Active low reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (2-bit)
    parameter S0 = 2'd0;  // No match
    parameter S1 = 2'd1;  // Matched '1'
    parameter S2 = 2'd2;  // Matched '10'
    parameter S3 = 2'd3;  // Matched '100'

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            S0: begin
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = S1;
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic (Mealy): sequence_detected is high when transitioning from S3 to S1 (input '1' completes "1001")
    always @(*) begin
        sequence_detected = (state == S3) && (data_in == 1'b1);
    end

endmodule