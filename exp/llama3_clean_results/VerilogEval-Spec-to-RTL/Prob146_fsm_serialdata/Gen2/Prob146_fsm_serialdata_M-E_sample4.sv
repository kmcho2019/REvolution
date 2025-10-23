module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define the states of the FSM
enum logic [1:0] {
    Idle,
    Receive,
    Done
} state, next_state;

// Define the shift register to store the incoming bits
logic [9:0] shift_register;

// Define the buffer to store the valid data byte
logic [7:0] data_buffer;

// Define the counter to keep track of the number of bits received
logic [3:0] bit_counter;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        shift_register <= 10'b0;
        data_buffer <= 8'b0;
        bit_counter <= 4'b0;
    end else begin
        case (state)
            Idle: begin
                if (in == 0) begin
                    // Start bit received, transition to Receive state
                    state <= Receive;
                    shift_register <= {9'b0, in};
                    bit_counter <= 4'b1;
                end else begin
                    // Still in Idle state
                    state <= Idle;
                end
            end
            Receive: begin
                // Shift in the current bit into the shift register
                shift_register <= {shift_register[8:0], in};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 4'b1010) begin
                    // Complete byte received, transition to Done state
                    state <= Done;
                end else begin
                    // Still in Receive state
                    state <= Receive;
                end
            end
            Done: begin
                // Check the validity of the byte and output the data byte
                if (shift_register[9] == 1) begin
                    // Valid byte, output the data byte
                    data_buffer <= shift_register[8:1];
                end
                // Transition back to Idle state
                state <= Idle;
            end
            default: state <= Idle;
        endcase
    end
end

// Combinational logic
assign done = (state == Done);
assign out_byte = data_buffer;

endmodule