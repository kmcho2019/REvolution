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

    // Detect conditions in combinational block for clarity:
    reg disc_detected, flag_detected;

    always @(*) begin
        // Default next state
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
                    next_state = 4'd0;
                    // zero after 5 ones detected -> discard next cycle
                    disc_detected = 1'b1;
                end
            end
            4'd6: begin
                if (in)
                    next_state = 4'd7; // error state
                else begin
                    next_state = 4'd0;
                    // zero after 6 ones detected -> flag next cycle
                    flag_detected = 1'b1;
                end
            end
            4'd7: begin
                // error state: 7 or more consecutive ones
                if (!in)
                    next_state = 4'd0;
                else
                    next_state = 4'd7;
            end
            default: next_state = 4'd0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= 4'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs asserted one cycle after detection
            // disc and flag asserted if detected in previous cycle
            // err asserted continuously while in error state
            disc <= disc_detected;
            flag <= flag_detected;
            err  <= (next_state == 4'd7);
        end
    end

endmodule