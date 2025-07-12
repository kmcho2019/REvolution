module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State represents count of consecutive ones (0 to 7)
    // 0..5: count of ones
    // 6: detected six consecutive ones
    // 7: error (7 or more ones)
    reg [2:0] state, next_state;

    always @(*) begin
        // Default next state
        next_state = state;
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        case (state)
            3'd0: begin // no previous ones
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
                    // After 5 ones, zero causes discard (disc)
                    next_state = 3'd0;
                    disc = 1'b1;
                end
            end
            3'd6: begin
                if (in)
                    next_state = 3'd7; // error state
                else begin
                    // After 6 ones, zero causes flag
                    next_state = 3'd0;
                    flag = 1'b1;
                end
            end
            3'd7: begin
                // Error state: 7 or more ones
                err = 1'b1;
                if (~in)
                    next_state = 3'd0;
                else
                    next_state = 3'd7;
            end
            default: begin
                next_state = 3'd0;
            end
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            state <= next_state;
            // Outputs are one cycle pulse synchronous with clk
            // (already assigned combinationally, updated here to registers)
        end
    end

endmodule