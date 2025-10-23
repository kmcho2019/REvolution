module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// State encoding
localparam IDLE      = 2'b00;
localparam COUNT_UP  = 2'b01;
localparam COUNT_DOWN = 2'b10;

reg [1:0] state, next_state;

// Combinational next state and output logic
wire at_max = &wave;      // wave == 31
wire at_min = ~|wave;     // wave == 0

assign next_state = 
    (~rst_n)           ? IDLE :
    (state == IDLE)    ? COUNT_UP :
    (state == COUNT_UP && at_max) ? COUNT_DOWN :
    (state == COUNT_DOWN && at_min) ? COUNT_UP :
    state;

// Waveform generation
wire [4:0] next_wave = 
    (~rst_n)           ? 5'b0 :
    (state == COUNT_UP) ? wave + 1'b1 :
    (state == COUNT_DOWN) ? wave - 1'b1 :
    wave;

// Sequential logic
always @(posedge clk) begin
    state <= next_state;
    wave <= next_wave;
end

endmodule