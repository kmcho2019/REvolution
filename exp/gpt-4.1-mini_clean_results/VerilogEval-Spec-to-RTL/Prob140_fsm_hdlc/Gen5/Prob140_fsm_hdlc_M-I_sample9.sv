module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Use 3 bits for state: counts consecutive ones 0..6, 7 = error
    reg [2:0] state, next_state;

    // Signals for detection of disc and flag conditions for next cycle output
    reg disc_dly, flag_dly;

    always @(*) begin
        // Default next state is current state
        next_state = state;

        // Disc and flag detected combinationally here
        disc_dly = 1'b0;
        flag_dly = 1'b0;

        if (state < 3'd5) begin
            // States 0..4: increment count on '1', else reset to 0
            if (in)
                next_state = state + 3'd1;
            else
                next_state = 3'd0;
        end else if (state == 3'd5) begin
            // State 5: if input=1 go to 6 else zero after 5 ones -> discard
            if (in)
                next_state = 3'd6;
            else begin
                next_state = 3'd0;
                disc_dly = 1'b1;
            end
        end else if (state == 3'd6) begin
            // State 6: if input=1 error state, else zero after 6 ones -> flag
            if (in)
                next_state = 3'd7;
            else begin
                next_state = 3'd0;
                flag_dly = 1'b1;
            end
        end else begin
            // Error state 7: stay if input=1 else reset
            if (in)
                next_state = 3'd7;
            else
                next_state = 3'd0;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            state    <= 3'd0;
            disc     <= 1'b0;
            flag     <= 1'b0;
            err      <= 1'b0;
            disc_dly <= 1'b0;
            flag_dly <= 1'b0;
        end else begin
            state <= next_state;

            // Output signals asserted for exactly one clock cycle after detection
            disc <= disc_dly;
            flag <= flag_dly;
            err  <= (next_state == 3'd7);
        end
    end

endmodule