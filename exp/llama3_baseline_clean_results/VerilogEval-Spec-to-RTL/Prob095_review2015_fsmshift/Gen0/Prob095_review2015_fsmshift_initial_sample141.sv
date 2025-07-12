module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 2 states: IDLE and SHIFT
reg [1:0] counter; // counter to keep track of shift cycles
reg shift_ena_reg; // registered output

// define states
parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;

// define shift cycles
parameter SHIFT_CYCLES = 4;

always @(posedge clk) begin
    if (reset) begin
        state <= SHIFT;
        counter <= 2'b00;
        shift_ena_reg <= 1'b1;
    end else begin
        case (state)
            SHIFT: begin
                if (counter == SHIFT_CYCLES - 1) begin
                    state <= IDLE;
                    shift_ena_reg <= 1'b0;
                end else begin
                    counter <= counter + 1'b1;
                end
            end
            IDLE: begin
                // stay in IDLE state
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;

endmodule