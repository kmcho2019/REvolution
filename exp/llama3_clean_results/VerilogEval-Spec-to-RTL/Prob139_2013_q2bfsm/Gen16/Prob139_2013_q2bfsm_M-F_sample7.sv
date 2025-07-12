module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state; // 0: RESET, 1: INIT, 2: X_DETECT, 3: Y_WAIT, 4: Y_WAIT_G
reg [1:0] x_shift; // shift register to detect '101' sequence on 'x'
reg [1:0] y_timer; // counter to wait for 'y' to become high

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0; // reset state
        x_shift <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // RESET
                state <= 1; // transition to INIT state after reset
                x_shift <= 0;
                y_timer <= 0;
            end
            1: begin // INIT
                f <= 1; // set 'f' high for one clock cycle
                state <= 2; // transition to X_DETECT state
                x_shift <= 0;
            end
            2: begin // X_DETECT
                if (!resetn) begin
                    state <= 0; // reset state
                    x_shift <= 0;
                    y_timer <= 0;
                    f <= 0;
                    g <= 0;
                end else begin
                    x_shift <= {x_shift[0], x}; // shift 'x' into the register
                    if (x_shift == 2'b11) begin // check for '11' sequence
                        x_shift <= {1'b1, x}; // check for '101' sequence
                        if (x == 1'b0) begin
                            state <= 3; // transition to Y_WAIT state
                            g <= 1; // set 'g' high
                        end
                    end else if (x_shift == 2'b10) begin
                        x_shift <= {x_shift[0], x}; // check for '101' sequence
                        if (x == 1'b1) begin
                            state <= 3; // transition to Y_WAIT state
                            g <= 1; // set 'g' high
                        end
                    end else begin
                        x_shift <= {x_shift[0], x}; // shift 'x' into the register
                    end
                end
            end
            3: begin // Y_WAIT
                if (!resetn) begin
                    state <= 0; // reset state
                    x_shift <= 0;
                    y_timer <= 0;
                    f <= 0;
                    g <= 0;
                end else if (y) begin
                    state <= 4; // transition to Y_WAIT_G state
                    g <= 1; // set 'g' high
                    y_timer <= 0;
                end else begin
                    y_timer <= y_timer + 1; // increment counter
                    if (y_timer == 2) begin
                        g <= 0; // set 'g' low if 'y' does not become high within two clock cycles
                    end
                end
            end
            4: begin // Y_WAIT_G
                if (!resetn) begin
                    state <= 0; // reset state
                    x_shift <= 0;
                    y_timer <= 0;
                    f <= 0;
                    g <= 0;
                end else begin
                    g <= 1; // maintain 'g' high
                end
            end
        endcase
        if (state != 1) begin
            f <= 0; // ensure 'f' is low in all states except INIT
        end
    end
end

endmodule