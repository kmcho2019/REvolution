module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding (4 bits for clarity and room):
    // s0 - zero or no ones seen yet
    // s1..s6 - count of consecutive ones 1..6
    // disc_out - output disc asserted for one cycle (after 5 ones + 0)
    // flag_out - output flag asserted for one cycle (after 6 ones + 0)
    // err_out  - output err asserted continuously after detecting 7 or more ones
    localparam s0       = 4'd0;
    localparam s1       = 4'd1;
    localparam s2       = 4'd2;
    localparam s3       = 4'd3;
    localparam s4       = 4'd4;
    localparam s5       = 4'd5;
    localparam s6       = 4'd6;
    localparam disc_out = 4'd7;
    localparam flag_out = 4'd8;
    localparam err_out  = 4'd9;

    reg [3:0] curr_state, nxt_state;

    // Moore outputs depend on current state only
    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        case(curr_state)
            disc_out: disc = 1'b1;
            flag_out: flag = 1'b1;
            err_out:  err  = 1'b1;
            default: begin end
        endcase
    end

    // Next state logic
    always @(*) begin
        case(curr_state)
            s0: begin
                if (in)
                    nxt_state = s1;
                else
                    nxt_state = s0;
            end
            s1: begin
                if (in)
                    nxt_state = s2;
                else
                    nxt_state = s0;
            end
            s2: begin
                if (in)
                    nxt_state = s3;
                else
                    nxt_state = s0;
            end
            s3: begin
                if (in)
                    nxt_state = s4;
                else
                    nxt_state = s0;
            end
            s4: begin
                if (in)
                    nxt_state = s5;
                else
                    nxt_state = s0;
            end
            s5: begin
                if (in)
                    nxt_state = s6;
                else
                    // Exactly 5 ones followed by zero -> discard zero next cycle
                    nxt_state = disc_out;
            end
            s6: begin
                if (in)
                    // Seventh one detected - error state, assert err next cycle
                    nxt_state = err_out;
                else
                    // Exactly 6 ones followed by zero -> flag next cycle
                    nxt_state = flag_out;
            end
            disc_out: begin
                // disc asserted one cycle, now reset count depending on input
                if (in)
                    nxt_state = s1;
                else
                    nxt_state = s0;
            end
            flag_out: begin
                // flag asserted one cycle, now reset count depending on input
                if (in)
                    nxt_state = s1;
                else
                    nxt_state = s0;
            end
            err_out: begin
                // While input is 1, remain asserting err output continuously
                if (in)
                    nxt_state = err_out;
                else
                    // On zero, error condition cleared, go back to s0
                    nxt_state = s0;
            end
            default: begin
                nxt_state = s0;
            end
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            curr_state <= s0;
        else
            curr_state <= nxt_state;
    end

endmodule