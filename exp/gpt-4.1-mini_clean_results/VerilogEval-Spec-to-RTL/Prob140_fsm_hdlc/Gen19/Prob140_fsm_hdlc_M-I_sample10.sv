module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: number of consecutive ones (0 to 7)
    // 0-6 = counts, 7 = error (7 or more ones)
    reg [2:0] state, next_state;

    // Next-cycle outputs
    reg disc_next, flag_next, err_next;

    // Clock enable to avoid unnecessary transitions in error state
    wire clk_en = (state != 3'd7) || (in == 1'b0);

    // Combinational next state and output logic
    always @(*) begin
        // Default outputs
        disc_next = 1'b0;
        flag_next = 1'b0;
        err_next  = 1'b0;
        next_state = state;

        case(state)
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
                    disc_next = 1'b1; // Zero after five ones => discard bit
                end
            end
            3'd6: begin
                if (in)
                    next_state = 3'd7; // 7 ones => error
                else begin
                    next_state = 3'd0;
                    flag_next = 1'b1; // Zero after six ones => flag detected
                end
            end
            3'd7: begin // Error state: 7 or more ones
                if (in) begin
                    // Stay in error state on further ones
                    next_state = 3'd7;
                    err_next = 1'b1;
                end else begin
                    // Reset count on zero input from error state
                    next_state = 3'd0;
                end
            end
            default: next_state = 3'd0;
        endcase
    end

    // Sequential logic with clock enable and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            // Register outputs (Moore FSM)
            disc <= disc_next;
            flag <= flag_next;
            err  <= err_next;
            // State update with clock enable to reduce toggling in error state when input=1
            if (clk_en)
                state <= next_state;
            else
                state <= state;
        end
    end

endmodule