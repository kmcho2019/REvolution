module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Define states
enum logic [1:0] {IDLE, START_DATA, VERIFY_STOP} state, nextState;

// Data buffer
reg [7:0] data_buffer;

// Counter for data bits
reg [2:0] data_bit_counter;

// Timeout counter
reg [3:0] timeout_counter;

// Combinatorial logic for next state and signal updates
always_comb begin
    // Default values
    nextState = state;
    done = 1'b0;
    
    case(state)
        IDLE: begin
            if(in == 1'b0) begin
                nextState = START_DATA;
            end
        end
        START_DATA: begin
            if(data_bit_counter == 8) begin
                nextState = VERIFY_STOP;
            end else begin
                nextState = START_DATA;
            end
        end
        VERIFY_STOP: begin
            if(in == 1'b1) begin
                done = 1'b1;
                nextState = IDLE;
            end else if(timeout_counter == 4'b1111) begin
                nextState = IDLE;
            end
        end
    endcase
end

// Sequential logic for state and signal updates
always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
        data_buffer <= 8'b0;
        data_bit_counter <= 3'b0;
        timeout_counter <= 4'b0;
        done <= 1'b0;
    end else begin
        case(state)
            IDLE: begin
                // Reset on idle
                data_buffer <= 8'b0;
                data_bit_counter <= 3'b0;
                timeout_counter <= 4'b0;
            end
            START_DATA: begin
                // Shift data bit into buffer
                data_buffer <= {data_buffer[6:0], in};
                data_bit_counter <= data_bit_counter + 1;
            end
            VERIFY_STOP: begin
                // Increment timeout counter
                timeout_counter <= timeout_counter + 1;
            end
        endcase
        state <= nextState;
    end
end

endmodule