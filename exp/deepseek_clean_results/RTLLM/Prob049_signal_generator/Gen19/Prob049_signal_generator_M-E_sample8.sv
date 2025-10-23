module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// Direction is implicitly stored in wave[4]
wire direction = wave[4];  // MSB indicates direction (0=up, 1=down)

// Boundary detection
wire at_max = &wave[3:0];  // All lower bits set (wave = 31)
wire at_min = ~|wave;      // All bits zero (wave = 0)

// Next wave calculation with auto-reverse
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
    end else begin
        case ({direction, at_max, at_min})
            3'b000: wave <= wave + 1'b1;  // Incrementing normally
            3'b010: wave <= {1'b1, 4'b1110}; // At max, start decrementing
            3'b101: wave <= 5'b00001;     // At min, start incrementing
            3'b100: wave <= wave - 1'b1;  // Decrementing normally
            default: wave <= wave;        // Hold (shouldn't occur)
        endcase
    end
end

endmodule