module sequence_detector(
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding (binary encoding for 5 states)
    localparam [2:0]
        IDLE = 3'd0,
        S1   = 3'd1,  // matched '1'
        S2   = 3'd2,  // matched '10'
        S3   = 3'd3,  // matched '100'
        S4   = 3'd4;  // matched '1001' - sequence detected

    reg [2:0] current_state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // stay in S1 if input is '1', since sequence starts with '1'
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = S1; // restart matching from '1' if input is '1'
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S4; // sequence detected
                else
                    next_state = IDLE; // no match, restart
            end
            S4: begin
                // After detecting sequence, re-check input to allow overlapping sequences
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State flip-flops with asynchronous active low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Moore output: sequence_detected is high only in S4
    assign sequence_detected = (current_state == S4);

endmodule