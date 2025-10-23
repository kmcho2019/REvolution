module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0=up, 1=down
wire [4:0] next_wave;
wire next_direction;

// Combinational next-state logic
assign next_wave = direction ? wave - 1'b1 : wave + 1'b1;
assign next_direction = (!direction && (wave == 5'd31)) ? 1'b1 :
                       (direction && (wave == 5'd0)) ? 1'b0 :
                       direction;

// Sequential state update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end
    else begin
        wave <= next_wave;
        direction <= next_direction;
    end
end

endmodule