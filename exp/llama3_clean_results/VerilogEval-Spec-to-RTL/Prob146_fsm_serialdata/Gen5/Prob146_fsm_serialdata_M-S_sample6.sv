module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

// Define the states of the FSM using binary encoding
reg [1:0] state;
parameter Idle = 2'b00, Receive = 2'b01, WaitStop = 2'b10;

// Define the PISO shift register
reg [7:0] shift_reg;

// Define the counter to keep track of the number of data bits received
reg [2:0] bit_counter;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        shift_reg <= 8'b0;
        bit_counter <= 3'b0;
    end else begin
        case (state)
            Idle: begin
                if (in == 0) begin
                    // Start bit received, transition to Receive state
                    state <= Receive;
                    shift_reg <= 8'b0;
                    bit_counter <= 3'b0;
                end else begin
                    // Still in Idle state
                    state <= Idle;
                end
            end
            Receive: begin
                // Shift in the current bit into the shift register
                shift_reg <= {shift_reg[6:0], in};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'b111) begin
                    // 8 data bits received, transition to WaitStop state
                    state <= WaitStop;
                end else begin
                    // Still in Receive state
                    state <= Receive;
                end
            end
            WaitStop: begin
                if (in == 1) begin
                    // Stop bit received, output received data byte and transition back to Idle
                    state <= Idle;
                end else begin
                    // Wait for stop bit
                    state <= WaitStop;
                end
            end
            default: state <= Idle;
        endcase
    end
end

// Combinational logic
assign out_byte = shift_reg;
assign done = (state == WaitStop && in == 1);

endmodule