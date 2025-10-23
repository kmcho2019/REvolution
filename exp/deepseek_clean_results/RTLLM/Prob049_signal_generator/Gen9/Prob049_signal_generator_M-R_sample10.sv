module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = increment, 1 = decrement

wire next_state;
wire [4:0] next_wave;

// Combinational next state logic
assign next_state = (~state & (wave == 5'b11111)) | 
                    (state & (wave != 5'b00000));

// Combinational next wave logic
assign next_wave = (~rst_n) ? 5'b00000 :
                   (~state) ? ((wave == 5'b11111) ? wave : wave + 1'b1) :
                   ((wave == 5'b00000) ? wave : wave - 1'b1);

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b00000;
        state <= 1'b0;
    end else begin
        wave <= next_wave;
        state <= next_state;
    end
end

endmodule