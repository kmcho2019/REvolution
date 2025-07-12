module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [1:0] state; // 2-bit state register
reg [1:0] nextState; // Next state register
reg disc_reg, flag_reg, err_reg; // Output registers

// State encoding:
// 00: IDLE
// 01: ONE
// 10: FIVE Ones
// 11: FLAG

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to IDLE state
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        state <= nextState; // Update state
    end
end

always @(*) begin
    case (state)
        2'b00: begin // IDLE state
            if (in) begin
                nextState = 2'b01; // Transition to ONE state
            end else begin
                nextState = 2'b00; // Stay in IDLE state
            end
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        2'b01: begin // ONE state
            if (in) begin
                nextState = 2'b01; // Stay in ONE state
            end else begin
                nextState = 2'b00; // Transition to IDLE state
            end
            disc_reg = 0;
            flag_reg = 0;
            err_reg = 0;
        end
        2'b10: begin // FIVE Ones state
            if (in) begin
                nextState = 2'b10; // Stay in FIVE Ones state
                err_reg = 1; // Assert err signal
            end else begin
                nextState = 2'b11; // Transition to FLAG state
                disc_reg = 1; // Assert disc signal
            end
            flag_reg = 0;
        end
        2'b11: begin // FLAG state
            if (~in) begin
                nextState = 2'b00; // Transition to IDLE state
                flag_reg = 1; // Assert flag signal
            end else begin
                nextState = 2'b11; // Stay in FLAG state
            end
            disc_reg = 0;
            err_reg = 0;
        end
    endcase
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule