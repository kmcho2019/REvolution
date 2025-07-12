module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    // Define states
    parameter IDLE = 4'd0;
    parameter CONSEC_1 = 4'd1;
    parameter CONSEC_2 = 4'd2;
    parameter CONSEC_3 = 4'd3;
    parameter CONSEC_4 = 4'd4;
    parameter CONSEC_5 = 4'd5;
    parameter CONSEC_6 = 4'd6;

    // Current state and next state
    reg [3:0] state, next_state;

    // Output signals
    reg disc_reg, flag_reg, err_reg;

    // Assign initial state
    initial state = IDLE;

    // Combinational logic for next state and output signals
    always @(*)
    begin
        disc_reg = 1'b0;
        flag_reg = 1'b0;
        err_reg = 1'b0;

        case (state)
            IDLE:
                if (in) next_state = CONSEC_1;
                else next_state = IDLE;

            CONSEC_1:
                if (in) next_state = CONSEC_2;
                else next_state = IDLE;

            CONSEC_2:
                if (in) next_state = CONSEC_3;
                else next_state = IDLE;

            CONSEC_3:
                if (in) next_state = CONSEC_4;
                else next_state = IDLE;

            CONSEC_4:
                if (in) next_state = CONSEC_5;
                else next_state = IDLE;

            CONSEC_5:
                if (in) next_state = CONSEC_6;
                else next_state = IDLE;

            CONSEC_6:
                if (in) begin
                    next_state = CONSEC_6;
                    err_reg = 1'b1;
                end
                else begin
                    next_state = IDLE;
                    flag_reg = 1'b1;
                end;

            default:
                next_state = IDLE;

        endcase

        if (state == CONSEC_5 && ~in) begin
            disc_reg = 1'b1;
            next_state = CONSEC_1;
        end

    end

    // Sequential logic for state update
    always @(posedge clk or posedge reset)
    begin
        if (reset) begin
            state <= IDLE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
        end
        else begin
            state <= next_state;
            disc <= disc_reg;
            flag <= flag_reg;
            err <= err_reg;
        end
    end

endmodule