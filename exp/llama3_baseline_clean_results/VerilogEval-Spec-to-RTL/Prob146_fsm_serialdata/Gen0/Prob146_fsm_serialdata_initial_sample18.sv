module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Enum for the states
enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP,
    ERROR
} state, next_state;

// Counter for the data bits
logic [2:0] data_count;
logic [2:0] next_data_count;

// Shift register for the data bits
logic [7:0] data_reg;
logic [7:0] next_data_reg;

// Assign the output done
assign done = (state == STOP);

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_count <= 0;
        data_reg <= 0;
    end else begin
        state <= next_state;
        data_count <= next_data_count;
        data_reg <= next_data_reg;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    next_data_count = data_count;
    next_data_reg = data_reg;

    case (state)
        IDLE: begin
            if (!in) begin
                next_state = START;
            end
        end
        START: begin
            next_state = DATA;
            next_data_reg = 0;
            next_data_count = 0;
        end
        DATA: begin
            next_data_reg = {data_reg[6:0], in};
            next_data_count = data_count + 1;
            if (data_count == 7) begin
                next_state = STOP;
            end
        end
        STOP: begin
            if (in) begin
                next_state = IDLE;
                out_byte = data_reg;
            end else begin
                next_state = ERROR;
            end
        end
        ERROR: begin
            if (in) begin
                next_state = IDLE;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule