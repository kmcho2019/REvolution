module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // Define states
    parameter PREV_0 = 0;
    parameter CNT_1  = 1;
    parameter CNT_2  = 2;
    parameter CNT_3  = 3;
    parameter CNT_4  = 4;
    parameter CNT_5  = 5;
    parameter CNT_6  = 6;
    parameter ERR    = 7;

    reg [2:0] current_state, next_state;
    reg disc_reg, flag_reg, err_reg;

    // State transition logic
    always @(*) begin
        case (current_state)
            PREV_0: next_state = in ? CNT_1 : PREV_0;
            CNT_1:  next_state = in ? CNT_2 : PREV_0;
            CNT_2:  next_state = in ? CNT_3 : PREV_0;
            CNT_3:  next_state = in ? CNT_4 : PREV_0;
            CNT_4:  next_state = in ? CNT_5 : PREV_0;
            CNT_5:  next_state = in ? CNT_6 : PREV_0;
            CNT_6:  next_state = in ? ERR   : PREV_0;
            ERR:    next_state = in ? ERR   : PREV_0;
            default:next_state = PREV_0;
        endcase
    end

    // Output logic (registered)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= PREV_0;
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
        end else begin
            current_state <= next_state;
            
            // Clear outputs unless new condition detected
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
            
            // Check for conditions based on current state and input
            if (current_state == CNT_5 && !in) begin
                disc_reg <= 1;
            end
            if (current_state == CNT_6 && !in) begin
                flag_reg <= 1;
            end
            if (current_state == ERR) begin
                err_reg <= 1;
            end
        end
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule