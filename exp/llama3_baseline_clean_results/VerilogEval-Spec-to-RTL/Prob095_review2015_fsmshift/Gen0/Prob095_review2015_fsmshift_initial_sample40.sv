module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

// Define states of the FSM
enum logic [1:0] {IDLE, SHIFT} state, next_state;

// Counter to keep track of the number of clock cycles
reg [1:0] counter;
reg [1:0] next_counter;

// Synchronous reset
always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        counter <= 0;
    end else begin
        state <= next_state;
        counter <= next_counter;
    end
end

// Next state and counter logic
always @(*) begin
    next_state = state;
    next_counter = counter;
    shift_ena = 1'b0;
    case(state)
        IDLE: begin
            next_state = SHIFT;
            next_counter = 0;
            shift_ena = 1'b1;
        end
        SHIFT: begin
            next_counter = counter + 1;
            shift_ena = 1'b1;
            if(counter == 3) begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule