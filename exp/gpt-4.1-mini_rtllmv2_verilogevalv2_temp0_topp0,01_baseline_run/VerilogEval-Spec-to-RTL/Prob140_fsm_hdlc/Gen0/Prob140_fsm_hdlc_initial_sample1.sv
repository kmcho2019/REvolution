module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding: number of consecutive 1s seen (0 to 6)
    // 0: no consecutive 1s
    // 1: one consecutive 1
    // ...
    // 6: six consecutive 1s
    reg [2:0] state, next_state;

    // Moore outputs depend on current state only
    // But outputs are asserted on the cycle after the condition occurs,
    // so outputs are registered and depend on previous state and input.

    // To implement this, we can generate outputs based on previous state and input,
    // and register them.

    reg disc_next, flag_next, err_next;

    always @(*) begin
        // Default next state and outputs
        next_state = 0;
        disc_next = 0;
        flag_next = 0;
        err_next = 0;

        case(state)
            3'd0: begin
                if(in)
                    next_state = 3'd1;
                else
                    next_state = 3'd0;
            end
            3'd1: begin
                if(in)
                    next_state = 3'd2;
                else
                    next_state = 3'd0;
            end
            3'd2: begin
                if(in)
                    next_state = 3'd3;
                else
                    next_state = 3'd0;
            end
            3'd3: begin
                if(in)
                    next_state = 3'd4;
                else
                    next_state = 3'd0;
            end
            3'd4: begin
                if(in)
                    next_state = 3'd5;
                else
                    next_state = 3'd0;
            end
            3'd5: begin
                if(in)
                    next_state = 3'd6;
                else begin
                    // input 0 after 5 consecutive 1s: discard this zero
                    next_state = 3'd0;
                    disc_next = 1'b1;
                end
            end
            3'd6: begin
                if(in) begin
                    // 7 or more consecutive 1s: error
                    next_state = 3'd6;
                    err_next = 1'b1;
                end else begin
                    // input 0 after 6 consecutive 1s: flag detected
                    next_state = 3'd0;
                    flag_next = 1'b1;
                end
            end
            default: next_state = 3'd0;
        endcase
    end

    always @(posedge clk) begin
        if(reset) begin
            state <= 3'd0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;
            disc <= disc_next;
            flag <= flag_next;
            err <= err_next;
        end
    end

endmodule