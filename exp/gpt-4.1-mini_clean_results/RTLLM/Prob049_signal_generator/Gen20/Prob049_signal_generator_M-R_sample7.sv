module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // Define states for clarity
    localparam INC = 1'b0;
    localparam DEC = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (~rst_n) begin
            // Synchronous reset: reset state and wave to zero
            state <= INC;
            wave  <= 5'd0;
        end else begin
            case(state)
                INC: begin
                    if (wave == 5'd31) begin
                        state <= DEC;
                        wave  <= wave - 5'd1;
                    end else begin
                        wave <= wave + 5'd1;
                    end
                end
                DEC: begin
                    if (wave == 5'd0) begin
                        state <= INC;
                        wave  <= wave + 5'd1;
                    end else begin
                        wave <= wave - 5'd1;
                    end
                end
                default: begin
                    // Default safe state
                    state <= INC;
                    wave  <= 5'd0;
                end
            endcase
        end
    end

endmodule