module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

// Define the states of the FSM
enum logic [2:0] {IDLE, START, DATA, STOP} state, next_state;

// Data bits accumulator
logic [7:0] data;
logic [2:0] bit_counter;

// Output logic
assign done = (state == STOP) && (in == 1);

// Sequential logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        bit_counter <= 0;
        data <= 0;
    end else begin
        state <= next_state;
        case(state)
            START: begin
                data[0] <= in;
                bit_counter <= 1;
            end
            DATA: begin
                data[bit_counter] <= in;
                bit_counter <= bit_counter + 1;
            end
        endcase
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    case(state)
        IDLE: begin
            if(in == 0) begin
                next_state = START;
            end
        end
        START: begin
            next_state = DATA;
        end
        DATA: begin
            if(bit_counter == 8) begin
                next_state = STOP;
            end else begin
                next_state = DATA;
            end
        end
        STOP: begin
            if(in == 1) begin
                next_state = IDLE;
            end else begin
                next_state = STOP;
            end
        end
    endcase
end

endmodule