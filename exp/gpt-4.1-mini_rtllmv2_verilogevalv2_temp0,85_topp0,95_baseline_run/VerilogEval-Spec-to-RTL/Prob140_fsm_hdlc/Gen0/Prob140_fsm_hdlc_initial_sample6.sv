module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding: number of consecutive 1s seen after a leading 0
    // 0: last input was 0 or reset state (count=0)
    // 1..7: count of consecutive 1s seen (up to 7)
    // 7 or more is error state

    reg [3:0] state, next_state;

    // On reset, state=0, outputs cleared
    // Moore outputs depend on state and input (next state) so outputs are registered from previous next_state

    // We will generate outputs based on state and input for the *next* cycle outputs

    always @(*) begin
        // Default next state is 0 for safe default
        next_state = 0;
        disc = 0;
        flag = 0;
        err  = 0;

        case(state)
            0: begin
                if (in == 1)
                    next_state = 1;
                else
                    next_state = 0;
            end
            1: begin
                if (in == 1)
                    next_state = 2;
                else
                    next_state = 0;
            end
            2: begin
                if (in == 1)
                    next_state = 3;
                else
                    next_state = 0;
            end
            3: begin
                if (in == 1)
                    next_state = 4;
                else
                    next_state = 0;
            end
            4: begin
                if (in == 1)
                    next_state = 5;
                else
                    next_state = 0;
            end
            5: begin
                if (in == 1)
                    next_state = 6;
                else begin
                    // input 0 after 5 consecutive 1s means a bit to discard (bit stuffed zero)
                    // output disc next cycle
                    next_state = 0;
                    disc = 1;
                end
            end
            6: begin
                if (in == 1) begin
                    // 7 or more ones => error
                    next_state = 7;
                    err = 1;
                end else begin
                    // input 0 after 6 consecutive 1s means flag detected
                    next_state = 0;
                    flag = 1;
                end
            end
            7: begin
                // error state: stay here if input is 1 or reset to 0 if input 0
                err = 1;
                if (in == 1)
                    next_state = 7;
                else
                    next_state = 0;
            end
            default: begin
                next_state = 0;
            end
        endcase
    end

    // Registers for state and outputs - outputs are registered, so output signals are asserted one cycle after detection

    reg disc_r, flag_r, err_r;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            disc_r <= 0;
            flag_r <= 0;
            err_r  <= 0;
        end else begin
            state <= next_state;
            // outputs asserted one cycle after condition occurs
            disc_r <= disc;
            flag_r <= flag;
            err_r  <= err;
        end
    end

    assign disc = disc_r;
    assign flag = flag_r;
    assign err  = err_r;

endmodule