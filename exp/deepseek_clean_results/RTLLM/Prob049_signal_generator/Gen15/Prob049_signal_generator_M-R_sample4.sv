module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// State parameters
parameter INC = 1'b0;
parameter DEC = 1'b1;

reg direction;  // INC or DEC

// Combinational next value calculation
wire [4:0] next_wave = direction ? wave - 1'b1 : wave + 1'b1;

// Boundary detection
wire at_max = &wave;    // All 1's (31)
wire at_min = ~|wave;   // All 0's (0)

// Next state logic
wire next_direction = (direction == INC) ? 
                     (at_max ? DEC : INC) :
                     (at_min ? INC : DEC);

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= INC;
    end else begin
        direction <= next_direction;
        if ((direction == INC && !at_max) || 
            (direction == DEC && !at_min)) begin
            wave <= next_wave;
        end
    end
end

endmodule