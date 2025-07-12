module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define the states of the FSM
logic [1:0] state, next_state;

// Define the register to store the received data byte
logic [7:0] data_byte;

// Define the counter to keep track of the number of data bits received
logic [2:0] bit_counter;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        data_byte <= 8'b0;
        bit_counter <= 3'b0;
    end else begin
        case (state)
            2'b00: begin // Idle
                if (in == 0) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin // Start
                if (in == 0) begin
                    state <= 2'b10;
                    bit_counter <= 3'b1;
                    data_byte <= {7'b0, in};
                end else begin
                    state <= 2'b00;
                end
            end
            2'b10: begin // Receive
                if (bit_counter < 3'b1000) begin
                    data_byte <= {data_byte[6:0], in};
                    bit_counter <= bit_counter + 1;
                end else begin
                    state <= 2'b11;
                end
            end
            2'b11: begin // Stop
                if (in == 1) begin
                    state <= 2'b00;
                end
            end
        endcase
    end
end

// Combinational logic
assign done = (state == 2'b11 && in == 1);
assign out_byte = data_byte;

endmodule