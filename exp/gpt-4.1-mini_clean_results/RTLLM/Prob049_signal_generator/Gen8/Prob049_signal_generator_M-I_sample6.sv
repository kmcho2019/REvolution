module signal_generator (
    input        clk,
    input        rst_n,
    output reg [4:0] wave
);

    localparam MAX_WAVE = 5'd31;

    // state: 0 = increment, 1 = decrement
    reg state;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: begin // increment
                    if (wave == MAX_WAVE) begin
                        state <= 1'b1; // change to decrement
                        // hold wave at MAX_WAVE (no assignment)
                    end else begin
                        wave <= wave + 1'b1;
                    end
                end
                1'b1: begin // decrement
                    if (wave == 5'd0) begin
                        state <= 1'b0; // change to increment
                        // hold wave at 0 (no assignment)
                    end else begin
                        wave <= wave - 1'b1;
                    end
                end
            endcase
        end
    end

endmodule