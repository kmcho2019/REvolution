module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define the states of the FSM
enum logic [2:0] {
    Idle,
    Receive,
    Verify,
    Done
} state, next_state;

// Define the register to store the received data byte
logic [7:0] data_byte;

// Define the counter to keep track of the number of data bits received
logic [2:0] bit_counter;

// Define the current bit of the received data byte
logic current_bit;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        data_byte <= 8'b0;
        bit_counter <= 3'b0;
    end else begin
        state <= next_state;
        case (state)
            Idle: begin
                if (in == 0) begin
                    // Start bit received, transition to Receive state
                    next_state <= Receive;
                    data_byte <= 8'b0;
                    bit_counter <= 3'b0;
                end else begin
                    // Still in Idle state
                    next_state <= Idle;
                end
            end
            Receive: begin
                // Shift in the current bit into the data byte
                data_byte <= {data_byte[6:0], in};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'b1000) begin
                    // 8 data bits received, transition to Verify state
                    next_state <= Verify;
                end else begin
                    // Still in Receive state
                    next_state <= Receive;
                end
            end
            Verify: begin
                if (in == 1) begin
                    // Stop bit received, transition to Done state
                    next_state <= Done;
                end else begin
                    // Wait for stop bit
                    next_state <= Verify;
                end
            end
            Done: begin
                // Assert done signal and output received byte
                next_state <= Idle;
            end
            default: next_state <= Idle;
        endcase
    end
end

// Combinational logic
always_comb begin
    case (state)
        Idle: done = 0;
        Receive: done = 0;
        Verify: done = 0;
        Done: done = 1;
        default: done = 0;
    endcase
    out_byte = data_byte;
end

endmodule