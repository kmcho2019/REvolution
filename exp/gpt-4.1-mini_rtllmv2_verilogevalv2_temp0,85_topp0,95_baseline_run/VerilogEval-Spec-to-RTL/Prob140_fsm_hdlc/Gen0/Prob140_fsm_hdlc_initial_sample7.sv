module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding: number of consecutive ones seen (0 to 6)
    // 0: last bit was zero or reset
    // 1..6: count of consecutive ones
    reg [2:0] state, next_state;

    // Intermediate output signals computed combinationally based on current state and input,
    // then registered on next clock cycle to produce outputs.
    reg disc_next, flag_next, err_next;

    always @(*) begin
        // Default next state and outputs
        disc_next = 0;
        flag_next = 0;
        err_next  = 0;

        case(state)
            3'd0: begin
                if (in)
                    next_state = 3'd1;
                else
                    next_state = 3'd0;
            end
            3'd1: begin
                if (in)
                    next_state = 3'd2;
                else
                    next_state = 3'd0;
            end
            3'd2: begin
                if (in)
                    next_state = 3'd3;
                else
                    next_state = 3'd0;
            end
            3'd3: begin
                if (in)
                    next_state = 3'd4;
                else
                    next_state = 3'd0;
            end
            3'd4: begin
                if (in)
                    next_state = 3'd5;
                else
                    next_state = 3'd0;
            end
            3'd5: begin
                if (in)
                    next_state = 3'd6;
                else begin
                    // 5 ones then zero: discard bit detected (0111110)
                    next_state = 3'd0;
                    disc_next = 1;
                end
            end
            3'd6: begin
                if (in) begin
                    // 7 or more ones: error
                    next_state = 3'd6;
                    err_next = 1;
                end else begin
                    // 6 ones then zero: flag detected (01111110)
                    next_state = 3'd0;
                    flag_next = 1;
                end
            end
            default: begin
                next_state = 3'd0;
            end
        endcase
    end

    // Sequential logic for state and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_next;
            flag  <= flag_next;
            err   <= err_next;
        end
    end

endmodule