module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// State encoding
localparam STATE_UP = 1'b0;
localparam STATE_DOWN = 1'b1;

reg state;
wire next_state;

// Boundary detection
wire at_max = (wave == 5'd31);
wire at_min = (wave == 5'd0);

// Next state logic (combinational)
assign next_state = (state == STATE_UP && at_max) ? STATE_DOWN :
                   (state == STATE_DOWN && at_min) ? STATE_UP :
                   state;

// Wave update logic (sequential)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        state <= STATE_UP;
    end else begin
        state <= next_state;
        case (state)
            STATE_UP:   wave <= wave + 1'b1;
            STATE_DOWN: wave <= wave - 1'b1;
        endcase
    end
end

endmodule