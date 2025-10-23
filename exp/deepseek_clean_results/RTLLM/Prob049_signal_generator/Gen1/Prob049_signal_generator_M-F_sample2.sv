module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// State definitions
localparam STATE_INC = 1'b0;
localparam STATE_DEC = 1'b1;

reg state;  // Current state (INC or DEC)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Active low reset - initialize to 0
        wave <= 5'd0;
        state <= STATE_INC;
    end else begin
        case (state)
            STATE_INC: begin  // Incrementing phase
                if (wave == 5'd31) begin  // Reached max value
                    state <= STATE_DEC;
                    wave <= wave - 1'b1;
                end else begin
                    wave <= wave + 1'b1;
                end
            end
            
            STATE_DEC: begin  // Decrementing phase
                if (wave == 5'd0) begin   // Reached min value
                    state <= STATE_INC;
                    wave <= wave + 1'b1;
                end else begin
                    wave <= wave - 1'b1;
                end
            end
        endcase
    end
end

endmodule