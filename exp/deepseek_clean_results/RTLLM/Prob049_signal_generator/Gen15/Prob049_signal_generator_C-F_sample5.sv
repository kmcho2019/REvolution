module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement

// Combinational logic for next state and wave
wire at_max = &wave;          // Efficient max value check
wire at_min = (wave == 5'b0); // Direct zero comparison
wire toggle_direction = (at_max && !direction) || (at_min && direction);
wire [4:0] next_wave = direction ? (wave - 1'b1) : (wave + 1'b1);

// State control always block
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        direction <= 1'b0;
    end else if (toggle_direction) begin
        direction <= ~direction;
    end
end

// Wave generation always block
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
    end else if (!toggle_direction) begin
        wave <= next_wave;
    end
end

endmodule