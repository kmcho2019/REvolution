module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

// Parameters for state encoding
localparam IDLE = 1'b0;
localparam MATCHING = 1'b1;

// State and shift register declarations
reg state;
reg [2:0] shift_reg;

// Next state and shift register logic
wire next_state;
wire [2:0] next_shift_reg = {shift_reg[1:0], data_in};

// State transition logic
assign next_state = (state == IDLE) ? 
                   (shift_reg[1:0] == 2'b10 && data_in == 1'b0) : 
                   1'b0; // Always return to IDLE after MATCHING

// Output generation
assign sequence_detected = (state == MATCHING) && data_in;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        state <= IDLE;
    end
    else begin
        shift_reg <= next_shift_reg;
        state <= next_state;
    end
end

endmodule