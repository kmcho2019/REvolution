module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Define states
enum logic [1:0] {IDLE, START, DATA, STOP} state, nextState;

// Counter for data bits
reg [2:0] data_bit_counter;

// Shift register for receiving data
reg [7:0] data_shift_reg;

// Combinatorial logic for next state and signal updates
always_comb begin
    // Default values
    nextState = state;
    
    case(state)
        IDLE: begin
            if(in == 1'b0) begin
                nextState = START;
            end
        end
        START: begin
            nextState = DATA;
        end
        DATA: begin
            if(data_bit_counter == 8) begin
                nextState = STOP;
            end else begin
                nextState = DATA;
            end
        end
        STOP: begin
            if(in == 1'b1) begin
                nextState = IDLE;
            end else begin
                nextState = STOP;
            end
        end
    endcase
end

// Sequential logic for state and signal updates
always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
        data_bit_counter <= 3'b0;
        data_shift_reg <= 8'b0;
        done <= 1'b0;
    end else begin
        case(state)
            IDLE: begin
                // Reset on idle
                data_bit_counter <= 3'b0;
                data_shift_reg <= 8'b0;
            end
            START: begin
                // Start bit detected, move to data reception
                data_shift_reg[7] <= in;
            end
            DATA: begin
                // Shift data bit into register
                data_shift_reg <= {data_shift_reg[6:0], in};
                data_bit_counter <= data_bit_counter + 1;
            end
            STOP: begin
                // Verify stop bit
                if(in == 1'b1) begin
                    done <= 1'b1;
                end
            end
        endcase
        state <= nextState;
    end
end

endmodule