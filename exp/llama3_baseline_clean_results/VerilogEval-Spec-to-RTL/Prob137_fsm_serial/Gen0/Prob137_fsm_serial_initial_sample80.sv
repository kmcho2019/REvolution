module TopModule (
    input  clk,
    input  reset,
    input  in,
    output done
);

// Define the states of the FSM
enum logic [2:0] { IDLE, START, DATA, STOP } state, next_state;

// Define a counter to keep track of the number of data bits received
logic [3:0] data_count;

// Define a register to store the received data
logic [7:0] data_reg;

// Define the output done
logic done_reg;

// Combinational logic to determine the next state
always_comb begin
    case (state)
        IDLE: begin
            if (in == 1'b0) next_state = START;
            else next_state = IDLE;
        end
        START: begin
            next_state = DATA;
        end
        DATA: begin
            if (data_count == 8) next_state = STOP;
            else next_state = DATA;
        end
        STOP: begin
            if (in == 1'b1) next_state = IDLE;
            else next_state = STOP;
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic to update the state and data
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_count <= 4'd0;
        data_reg <= 8'd0;
        done_reg <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                state <= next_state;
                data_count <= 4'd0;
                data_reg <= 8'd0;
                done_reg <= 1'b0;
            end
            START: begin
                state <= next_state;
            end
            DATA: begin
                state <= next_state;
                data_reg <= {data_reg[6:0], in}; // Shift in the data bit
                data_count <= data_count + 1'b1;
            end
            STOP: begin
                state <= next_state;
                if (in == 1'b1) done_reg <= 1'b1;
                else done_reg <= 1'b0;
            end
            default: state <= IDLE;
        endcase
    end
end

// Output logic
assign done = done_reg;

endmodule