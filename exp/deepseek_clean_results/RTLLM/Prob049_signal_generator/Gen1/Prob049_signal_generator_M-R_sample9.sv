module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// Define states
localparam UP = 1'b0;
localparam DOWN = 1'b1;

reg state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        state <= UP;
    end
    else begin
        // State transition logic
        case (state)
            UP: state <= (wave == 5'b11110) ? DOWN : UP;
            DOWN: state <= (wave == 5'b00001) ? UP : DOWN;
        endcase
        
        // Wave update logic
        case (state)
            UP: wave <= (wave == 5'b11111) ? wave : wave + 1'b1;
            DOWN: wave <= (wave == 5'b00000) ? wave : wave - 1'b1;
        endcase
    end
end

endmodule