module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;
reg [7:0] next_count;
reg wave_out_next;
reg [1:0] state, next_state;

// State machine states
localparam IDLE = 2'b00;
localparam COUNTING = 2'b01;

// Combinational logic for next state and counter increment
assign next_count = (state == IDLE) ? 8'd0 : (count == (freq - 1)) ? 8'd0 : count + 8'd1;
assign wave_out_next = (state == IDLE) ? ~wave_out : wave_out;
assign next_state = (state == IDLE) ? COUNTING : (count == (freq - 1)) ? IDLE : state;

// Sequential logic for state machine and counter
always @(posedge clk) begin
    count <= next_count;
    wave_out <= wave_out_next;
    state <= next_state;
end

// Explicit initialization of registers
initial begin
    count = 8'd0;
    wave_out = 1'b0;
    state = IDLE;
end

endmodule