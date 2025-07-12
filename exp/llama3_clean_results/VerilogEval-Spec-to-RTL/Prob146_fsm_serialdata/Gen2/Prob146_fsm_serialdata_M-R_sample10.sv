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
    Start,
    Receive,
    Stop
} state, next_state;

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
                    state <= Start;
                end else begin
                    state <= Idle;
                end
            end
            Start: begin
                if (in == 0) begin
                    state <= Receive;
                    bit_counter <= 3'b1;
                    data_byte <= {7'b0, in};
                end else begin
                    state <= Idle;
                end
            end
            Receive: begin
                if (bit_counter < 3'b1000) begin
                    data_byte <= {data_byte[6:0], in};
                    bit_counter <= bit_counter + 1;
                    state <= Receive;
                end else begin
                    state <= Stop;
                end
            end
            Stop: begin
                if (in == 1) begin
                    state <= Idle;
                end else begin
                    state <= Stop;
                end
            end
        endcase
    end
end

// Combinational logic
assign done = (state == Stop && in == 1);
assign out_byte = data_byte;

endmodule