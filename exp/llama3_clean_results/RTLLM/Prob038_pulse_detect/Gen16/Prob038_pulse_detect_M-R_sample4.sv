module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Finite state machine states: IDLE (2'b00), PULSE_START (2'b01), PULSE_END (2'b10)

// Define the states
parameter IDLE = 2'b00;
parameter PULSE_START = 2'b01;
parameter PULSE_END = 2'b10;

// Combinational logic for the next state and output
wire [1:0] state_next;
wire data_out_next;

assign state_next = (state == IDLE && data_in == 1'b1) ? PULSE_START :
                    (state == PULSE_START && data_in == 1'b0) ? PULSE_END :
                    (state == PULSE_END) ? IDLE :
                    state;

assign data_out_next = (state == PULSE_END) ? 1'b1 : 1'b0;

// Sequential logic for the FSM
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= state_next;
        data_out <= data_out_next;
    end
end

endmodule