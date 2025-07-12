module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    reg [2:0] state; // 0 - IDLE, 1 - ONE, 2 - ONES_2_TO_5, 3 - ONES_6, 4 - ONES_7_OR_MORE, 5 - FLAG, 6 - DISCARD
    reg [2:0] nextState;
    reg [2:0] counter; // Counter for consecutive ones
    reg flag_reg, err_reg, disc_reg; // registers for flag, error and discard

    // State encoding
    parameter IDLE = 3'b000;
    parameter ONE = 3'b001;
    parameter ONES_2_TO_5 = 3'b010;
    parameter ONES_6 = 3'b011;
    parameter ONES_7_OR_MORE = 3'b100;
    parameter FLAG = 3'b101;
    parameter DISCARD = 3'b110;

    always @(*) begin
        case (state)
            IDLE: begin
                if (in) begin
                    nextState = ONE;
                    counter = 1;
                end else begin
                    nextState = IDLE;
                    counter = 0;
                end
                flag_reg = 1'b0;
                err_reg = 1'b0;
                disc_reg = 1'b0;
            end
            ONE: begin
                if (in) begin
                    nextState = ONES_2_TO_5;
                    counter = counter + 1;
                end else begin
                    nextState = IDLE;
                    counter = 0;
                end
                flag_reg = 1'b0;
                err_reg = 1'b0;
                disc_reg = 1'b0;
            end
            ONES_2_TO_5: begin
                if (in) begin
                    nextState = (counter == 5) ? ONES_6 : ONES_2_TO_5;
                    counter = counter + 1;
                end else begin
                    nextState = IDLE;
                    counter = 0;
                end
                flag_reg = 1'b0;
                err_reg = 1'b0;
                disc_reg = 1'b0;
            end
            ONES_6: begin
                if (in) begin
                    nextState = ONES_7_OR_MORE;
                    counter = counter + 1;
                    flag_reg = 1'b1;
                end else begin
                    nextState = DISCARD;
                    disc_reg = 1'b1;
                end
                err_reg = 1'b0;
            end
            ONES_7_OR_MORE: begin
                if (in) begin
                    nextState = ONES_7_OR_MORE;
                    counter = counter + 1;
                    err_reg = 1'b1;
                end else begin
                    nextState = IDLE;
                    counter = 0;
                    err_reg = 1'b0;
                end
                flag_reg = 1'b0;
                disc_reg = 1'b0;
            end
            FLAG: begin
                nextState = IDLE;
                flag_reg = 1'b0;
                err_reg = 1'b0;
                disc_reg = 1'b0;
            end
            DISCARD: begin
                nextState = IDLE;
                flag_reg = 1'b0;
                err_reg = 1'b0;
                disc_reg = 1'b0;
            end
            default: begin
                nextState = IDLE;
                counter = 0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
                disc_reg = 1'b0;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            flag <= 1'b0;
            err <= 1'b0;
            disc <= 1'b0;
        end else begin
            state <= nextState;
            flag <= flag_reg;
            err <= err_reg;
            disc <= disc_reg;
        end
    end

endmodule