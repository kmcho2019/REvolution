module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define the states of the FSM
enum logic [1:0] {IDLE, RECEIVE, STOP} state, next_state;

// Register to store the received byte
logic [7:0] byte;

// Counter for the data bits
logic [2:0] bit_count;

// Counter to keep track of the number of bits received
logic [2:0] receive_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte <= 8'b0;
        bit_count <= 3'b0;
        receive_count <= 3'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    state <= RECEIVE;
                    receive_count <= 3'b1;
                    byte[0] <= in;
                    bit_count <= 3'b1;
                end
            end
            RECEIVE: begin
                if (receive_count == 8) begin
                    state <= STOP;
                end else begin
                    byte[receive_count] <= in;
                    receive_count <= receive_count + 1;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

assign out_byte = (state == STOP) ? byte : 8'b0;
assign done = (state == STOP) && (in == 1'b1);

endmodule