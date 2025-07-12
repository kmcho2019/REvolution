module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

wire direction;  // 0 = increment, 1 = decrement
wire at_max = &wave;    // wave == 31
wire at_min = ~|wave;   // wave == 0

// Direction prediction logic
assign direction = (at_max || (!at_min && wave[4]));

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
    end else begin
        // Single arithmetic operation with predicted direction
        wave <= direction ? (wave - 1) : (wave + 1);
    end
end

endmodule