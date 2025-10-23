module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define the states
enum logic [1:0] {
    IDLE = 2'b00,
    SHIFT = 2'b01,
    COUNT = 2'b10,
    WAIT_ACK = 2'b11
} state, next_state;

// Pattern detection register
reg [3:0] pattern_reg;

// Counter for shift and wait phases
reg [1:0] counter;

// Sequential logic for state and counter updates
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_reg <= 0;
        counter <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern_reg <= {pattern_reg[2:0], data};
                if (pattern_reg == 4'b1101) begin
                    state <= SHIFT;
                    counter <= 1;
                end
            end
            SHIFT: begin
                counter <= counter + 1;
                if (counter == 4) begin
                    state <= COUNT;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= WAIT_ACK;
                end
            end
            WAIT_ACK: begin
                if (ack) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

// Combinational logic for output signal generation
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNT);
assign done = (state == WAIT_ACK);

endmodule