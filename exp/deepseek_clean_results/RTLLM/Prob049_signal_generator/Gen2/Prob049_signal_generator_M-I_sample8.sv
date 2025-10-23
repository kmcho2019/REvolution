module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// State definitions
localparam UP = 1'b0;
localparam DOWN = 1'b1;
reg state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Active-low reset initialization
        wave <= 5'b0;
        state <= UP;  // Start counting up
    end
    else begin
        case (state)
            UP: begin
                if (wave == 5'b11111) begin  // Reached max (31)
                    wave <= wave - 1'b1;
                    state <= DOWN;
                end
                else begin
                    wave <= wave + 1'b1;
                end
            end
            DOWN: begin
                if (wave == 5'b00000) begin  // Reached min (0)
                    wave <= wave + 1'b1;
                    state <= UP;
                end
                else begin
                    wave <= wave - 1'b1;
                end
            end
        endcase
    end
end

endmodule