module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: count consecutive ones, 7 = error
    reg [3:0] state, next_state;

    // Detection flags to indicate output assertion next cycle
    reg disc_detected, flag_detected;

    always @(*) begin
        // Default assignments
        next_state = state;
        disc_detected = 1'b0;
        flag_detected = 1'b0;

        case (state)
            4'd0: next_state = (in) ? 4'd1 : 4'd0;
            4'd1: next_state = (in) ? 4'd2 : 4'd0;
            4'd2: next_state = (in) ? 4'd3 : 4'd0;
            4'd3: next_state = (in) ? 4'd4 : 4'd0;
            4'd4: next_state = (in) ? 4'd5 : 4'd0;
            4'd5: begin
                if (in)
                    next_state = 4'd6;
                else begin
                    next_state = 4'd0;
                    disc_detected = 1'b1; // zero after 5 ones detected
                end
            end
            4'd6: begin
                if (in)
                    next_state = 4'd7;
                else begin
                    next_state = 4'd0;
                    flag_detected = 1'b1; // zero after 6 ones detected
                end
            end
            4'd7: next_state = (in) ? 4'd7 : 4'd0; // error state
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

            // Outputs are asserted exactly one cycle after detection
            disc <= disc_detected;
            flag <= flag_detected;
            err  <= (state == 4'd7);
        end
    end

endmodule