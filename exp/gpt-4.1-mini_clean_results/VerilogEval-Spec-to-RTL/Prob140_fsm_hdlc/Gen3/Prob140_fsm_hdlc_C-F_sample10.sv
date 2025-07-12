module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: 0..6 count consecutive ones, 7 = error state
    reg [3:0] state, next_state;

    // Detection signals registered to delay assertion by one clock cycle
    reg disc_detected_r, flag_detected_r;

    // Combinational detection signals (one-cycle advance)
    reg disc_detected, flag_detected;

    // Next state logic and detection combinational block
    always @(*) begin
        next_state = state;
        disc_detected = 1'b0;
        flag_detected = 1'b0;

        case(state)
            4'd0: begin
                if (in)
                    next_state = 4'd1;
                else
                    next_state = 4'd0;
            end
            4'd1: begin
                if (in)
                    next_state = 4'd2;
                else
                    next_state = 4'd0;
            end
            4'd2: begin
                if (in)
                    next_state = 4'd3;
                else
                    next_state = 4'd0;
            end
            4'd3: begin
                if (in)
                    next_state = 4'd4;
                else
                    next_state = 4'd0;
            end
            4'd4: begin
                if (in)
                    next_state = 4'd5;
                else
                    next_state = 4'd0;
            end
            4'd5: begin
                if (in)
                    next_state = 4'd6;
                else begin
                    // Zero after exactly 5 ones -> discard zero next cycle
                    next_state = 4'd0;
                    disc_detected = 1'b1;
                end
            end
            4'd6: begin
                if (in)
                    // Seventh consecutive one -> error state next cycle
                    next_state = 4'd7;
                else begin
                    // Zero after exactly 6 ones -> flag next cycle
                    next_state = 4'd0;
                    flag_detected = 1'b1;
                end
            end
            4'd7: begin
                // Error state: 7 or more consecutive ones
                if (!in)
                    next_state = 4'd0;
                else
                    next_state = 4'd7;
            end
            default: next_state = 4'd0;
        endcase
    end

    // Sequential logic: state update and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= 4'd0;
            disc_detected_r <= 1'b0;
            flag_detected_r <= 1'b0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;

            // Register detection signals to assert outputs exactly one cycle after detection
            disc_detected_r <= disc_detected;
            flag_detected_r <= flag_detected;

            disc <= disc_detected_r;
            flag <= flag_detected_r;

            // err asserted continuously while in error state (7)
            err <= (next_state == 4'd7);
        end
    end

endmodule