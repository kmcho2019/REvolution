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
        state <= next_state;
        case (state)
            Receive: begin
                data_byte <= {data_byte[6:0], in};
                bit_counter <= bit_counter + 1;
            end
        endcase
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    done = 1'b0;
    case (state)
        Idle: begin
            if (in == 1'b0) begin
                next_state = Start;
            end
        end
        Start: begin
            next_state = Receive;
            bit_counter = 3'b1;
        end
        Receive: begin
            if (bit_counter == 3'b1000) begin
                next_state = Stop;
            end
        end
        Stop: begin
            if (in == 1'b1) begin
                next_state = Idle;
                done = 1'b1;
            end
        end
    endcase
end

// Assign output
assign out_byte = data_byte;

endmodule