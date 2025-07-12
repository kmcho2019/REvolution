module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

wire direction;  // 0 = increment, 1 = decrement
wire [4:0] next_wave = wave + {5{direction}} + {4'b0, ~direction};
wire will_hit_max = (wave == 5'b11110) & ~direction;
wire will_hit_min = (wave == 5'b00001) & direction;

assign direction = (~rst_n) ? 1'b0 : 
                  (will_hit_max | will_hit_min) ? ~direction : 
                  direction;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
    end else begin
        wave <= next_wave;
    end
end

// Direction flip-flop
reg dir_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dir_reg <= 1'b0;
    end else if (will_hit_max | will_hit_min) begin
        dir_reg <= ~dir_reg;
    end
end

endmodule