module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

// Define the states of the FSM using one-hot encoding
logic [2:0] state, next_state;
parameter Idle = 3'b001, Receive = 3'b010, Done = 3'b100;

// Define the register to store the received data byte
logic [7:0] data_byte;

// Define the counter to keep track of the number of data bits received
logic [2:0] bit_counter;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        data_byte <= 8'b0;
        bit_counter <= 3'b0;
    end else begin
        case (state)
            Idle: begin
                if (in == 0) begin
                    // Start bit received, transition to Receive state
                    state <= Receive;
                    data_byte <= 8'b0;
                    bit_counter <= 3'b0;
                end else begin
                    // Still in Idle state
                    state <= Idle;
                end
            end
            Receive: begin
                // Shift in the current bit into the data byte
                data_byte <= {data_byte[6:0], in};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'b111) begin
                    if (in == 1) begin
                        // Stop bit received, transition to Done state
                        state <= Done;
                    end else begin
                        // Wait for stop bit
                        state <= Receive;
                    end
                end else begin
                    // Still in Receive state
                    state <= Receive;
                end
            end
            Done: begin
                // Assert done signal and output received byte
                state <= Idle;
            end
            default: state <= Idle;
        endcase
    end
end

// Combinational logic
assign done = (state == Done);
assign out_byte = data_byte;

endmodule