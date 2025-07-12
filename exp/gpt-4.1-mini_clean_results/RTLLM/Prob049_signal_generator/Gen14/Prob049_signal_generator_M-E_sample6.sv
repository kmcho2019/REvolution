module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

    // Define states
    typedef enum logic [1:0] {
        INC = 2'b00,
        DEC = 2'b01
    } state_t;

    state_t state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= INC;
            wave <= 5'd0;
        end else begin
            case(state)
                INC: begin
                    if (wave == 5'd31) begin
                        state <= DEC;
                        wave <= wave - 1'b1;
                    end else begin
                        wave <= wave + 1'b1;
                    end
                end
                DEC: begin
                    if (wave == 5'd0) begin
                        state <= INC;
                        wave <= wave + 1'b1;
                    end else begin
                        wave <= wave - 1'b1;
                    end
                end
                default: begin
                    state <= INC;
                    wave <= 5'd0;
                end
            endcase
        end
    end

endmodule