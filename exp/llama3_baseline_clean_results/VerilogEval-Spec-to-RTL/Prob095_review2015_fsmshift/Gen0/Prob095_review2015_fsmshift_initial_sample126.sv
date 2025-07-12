module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state;
reg [1:0] next_state;
reg [1:0] counter;
reg [1:0] next_counter;
reg shift_ena_reg;
reg next_shift_ena;

// State definitions
localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam DONE = 2'b10;

// Counter definitions
localparam COUNTER_RESET = 2'b00;
localparam COUNTER_MAX = 2'b11;

always @(*) begin
    next_state = state;
    next_counter = counter;
    next_shift_ena = shift_ena_reg;

    case (state)
        IDLE: begin
            if (reset) begin
                next_state = SHIFT;
                next_counter = COUNTER_RESET;
                next_shift_ena = 1'b1;
            end else begin
                next_state = IDLE;
                next_shift_ena = 1'b0;
            end
        end
        SHIFT: begin
            next_shift_ena = 1'b1;
            if (counter == COUNTER_MAX) begin
                next_state = DONE;
                next_counter = COUNTER_RESET;
            end else begin
                next_state = SHIFT;
                next_counter = counter + 1;
            end
        end
        DONE: begin
            next_state = DONE;
            next_shift_ena = 1'b0;
        end
        default: begin
            next_state = IDLE;
            next_shift_ena = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        counter <= COUNTER_RESET;
        shift_ena_reg <= 1'b1;
    end else begin
        state <= next_state;
        counter <= next_counter;
        shift_ena_reg <= next_shift_ena;
    end
end

assign shift_ena = shift_ena_reg;

endmodule