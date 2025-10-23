module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // State encoding
    localparam INC = 1'b0;
    localparam DEC = 1'b1;

    reg state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave  <= 5'd0;
            state <= INC;
        end else begin
            // Temporary variables for next wave and next state
            reg [4:0] next_wave;
            reg       next_state;

            case(state)
                INC: begin
                    if (wave == 5'd31) begin
                        next_wave = wave - 5'd1;
                        next_state = DEC;
                    end else begin
                        next_wave = wave + 5'd1;
                        next_state = INC;
                    end
                end
                DEC: begin
                    if (wave == 5'd0) begin
                        next_wave = wave + 5'd1;
                        next_state = INC;
                    end else begin
                        next_wave = wave - 5'd1;
                        next_state = DEC;
                    end
                end
                default: begin
                    next_wave = 5'd0;
                    next_state = INC;
                end
            endcase

            wave  <= next_wave;
            state <= next_state;
        end
    end

endmodule