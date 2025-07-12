module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] state, next_state;
    reg disc_next, flag_next, err_next;

    always @(*) begin
        // Default assignments
        next_state = state;
        disc_next  = 1'b0;
        flag_next  = 1'b0;
        err_next   = 1'b0;

        case (state)
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
                    next_state = 3'd0;
                    disc_next = 1'b1;  // 5 ones then zero => discard zero
                end
            end
            3'd6: begin
                if (in)
                    next_state = 3'd7;
                else begin
                    next_state = 3'd0;
                    flag_next = 1'b1;  // 6 ones then zero => flag detected
                end
            end
            3'd7: begin
                // 7 or more ones => error
                err_next = 1'b1;
                if (in)
                    next_state = 3'd7;
                else
                    next_state = 3'd0;
            end
            default: next_state = 3'd0;
        endcase
    end

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