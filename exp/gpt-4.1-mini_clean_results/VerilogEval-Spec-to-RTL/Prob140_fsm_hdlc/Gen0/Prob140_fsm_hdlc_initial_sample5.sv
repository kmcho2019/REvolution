module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: 0 to 7 represent counts of consecutive ones
    // 7 = error state (7 or more consecutive ones)
    reg [3:0] state, next_state;

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= 4'd0;
        else
            state <= next_state;
    end

    // Combinational next state logic and output signaling
    always @(*) begin
        // default outputs zero
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;
        next_state = state;

        case(state)
            4'd0: begin // 0 consecutive ones
                if (in)
                    next_state = 4'd1;
                else
                    next_state = 4'd0;
            end
            4'd1: begin // 1 consecutive one
                if (in)
                    next_state = 4'd2;
                else
                    next_state = 4'd0;
            end
            4'd2: begin // 2 consecutive ones
                if (in)
                    next_state = 4'd3;
                else
                    next_state = 4'd0;
            end
            4'd3: begin // 3 consecutive ones
                if (in)
                    next_state = 4'd4;
                else
                    next_state = 4'd0;
            end
            4'd4: begin // 4 consecutive ones
                if (in)
                    next_state = 4'd5;
                else
                    next_state = 4'd0;
            end
            4'd5: begin // 5 consecutive ones
                if (in)
                    next_state = 4'd6;
                else begin
                    next_state = 4'd0;
                    disc = 1'b1; // disc signal: zero after 5 ones
                end
            end
            4'd6: begin // 6 consecutive ones
                if (in) begin
                    next_state = 4'd7; // error state (7 or more ones)
                end else begin
                    next_state = 4'd0;
                    flag = 1'b1; // flag detected
                end
            end
            4'd7: begin // error state (7 or more ones)
                err = 1'b1;
                if (!in)
                    next_state = 4'd0; // reset count on zero input
                else
                    next_state = 4'd7; // remain in error state
            end
            default: begin
                next_state = 4'd0;
            end
        endcase
    end

endmodule