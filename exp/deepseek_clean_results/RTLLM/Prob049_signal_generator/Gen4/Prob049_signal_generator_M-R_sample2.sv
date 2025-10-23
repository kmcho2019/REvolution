module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// State definitions
localparam STATE_UP = 1'b0;
localparam STATE_DOWN = 1'b1;

reg state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition
        wave <= 5'b0;
        state <= STATE_UP;
    end
    else begin
        case (state)
            STATE_UP: begin
                wave <= wave + 1'b1;
                if (wave == 5'b11110) // Check before last increment
                    state <= STATE_DOWN;
            end
            STATE_DOWN: begin
                wave <= wave - 1'b1;
                if (wave == 5'b00001) // Check before last decrement
                    state <= STATE_UP;
            end
        endcase
    end
end

endmodule