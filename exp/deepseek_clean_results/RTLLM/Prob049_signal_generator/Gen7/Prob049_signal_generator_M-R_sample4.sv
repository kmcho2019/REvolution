module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// State definitions
localparam INCREMENT = 1'b0;
localparam DECREMENT = 1'b1;

reg state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b00000;
        state <= INCREMENT;
    end
    else begin
        // State transition logic
        case (state)
            INCREMENT: state <= (wave == 5'b11111) ? DECREMENT : INCREMENT;
            DECREMENT: state <= (wave == 5'b00000) ? INCREMENT : DECREMENT;
        endcase
        
        // Wave update logic
        case (state)
            INCREMENT: wave <= (wave == 5'b11111) ? wave : wave + 1;
            DECREMENT: wave <= (wave == 5'b00000) ? wave : wave - 1;
        endcase
    end
end

endmodule