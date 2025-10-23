module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define states for the finite state machine
localparam IDLE = 2'b00;
localparam RECV = 2'b01;
localparam STOP = 2'b10;

reg [1:0] state;
reg [7:0] data;
reg [2:0] bit_counter;

// Combinational logic for next state
wire next_state_IDLE, next_state_RECV, next_state_STOP;
assign next_state_IDLE = (reset || (state == STOP && in)) || (state == IDLE && in);
assign next_state_RECV = state == IDLE && !in;
assign next_state_STOP = state == RECV && bit_counter == 3'd7;

// Combinational logic for output
assign done = state == STOP && in;

// Sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        bit_counter <= 3'b000;
        out_byte <= 8'b0;
        done <= 0;
    end else begin
        case(state)
            IDLE: begin
                if (next_state_RECV) begin
                    state <= RECV;
                    bit_counter <= 3'b000;
                end else if (next_state_IDLE) begin
                    state <= IDLE;
                end
            end
            RECV: begin
                data <= {in, data[7:1]}; // Shift data bits to the right
                bit_counter <= bit_counter + 1;
                if (next_state_STOP) begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (next_state_IDLE) begin
                    state <= IDLE;
                    out_byte <= data;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule