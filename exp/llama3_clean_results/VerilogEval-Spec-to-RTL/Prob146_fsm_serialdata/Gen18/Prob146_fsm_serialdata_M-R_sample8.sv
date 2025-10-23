module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP
} state, next_state;

// Current bit counter
reg [2:0] bit_counter;

// Data register to store the received bits
reg [7:0] data;

// Sequential logic to update the registers
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        bit_counter <= 0;
        data <= 8'b0;
        out_byte <= 8'b0;
        done <= 0;
    end
    else begin
        state <= next_state;
        case(next_state)
            START: begin
                bit_counter <= 0;
            end
            DATA: begin
                bit_counter <= bit_counter + 1;
                data[7 - bit_counter] <= in; // Store data bits in the correct order
            end
            STOP: begin
                if (in) begin // Verify stop bit
                    out_byte <= data; // Update out_byte
                end
            end
        endcase
    end
end

// Combinational logic to determine the next state
always @(*) begin
    case(state)
        IDLE: begin
            if (!in) begin
                next_state = START; // Transition to START state on start bit
            end
            else begin
                next_state = IDLE;
            end
        end
        START: begin
            next_state = DATA; // Transition to DATA state
        end
        DATA: begin
            if (bit_counter == 8) begin
                next_state = STOP; // Transition to STOP state after 8 data bits
            end
            else begin
                next_state = DATA;
            end
        end
        STOP: begin
            if (in) begin // Verify stop bit
                next_state = IDLE; // Transition to IDLE state
                done = 1; // Assert done signal
            end
            else begin
                next_state = STOP; // Wait for stop bit if it's incorrect
                done = 0; // Deassert done signal
            end
        end
    endcase
end

endmodule