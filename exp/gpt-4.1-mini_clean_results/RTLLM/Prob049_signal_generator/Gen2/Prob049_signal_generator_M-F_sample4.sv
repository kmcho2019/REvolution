module signal_generator (
    input        clk,
    input        rst_n,
    output reg [4:0] wave
);

    // state = 0 means counting up, state = 1 means counting down
    reg state;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0; // start counting up
        end else begin
            if (state == 1'b0) begin
                // counting up
                if (wave == 5'd31) begin
                    state <= 1'b1;   // switch to counting down
                    wave  <= wave - 1;
                end else begin
                    wave <= wave + 1;
                end
            end else begin
                // counting down
                if (wave == 5'd0) begin
                    state <= 1'b0;   // switch to counting up
                    wave  <= wave + 1;
                end else begin
                    wave <= wave - 1;
                end
            end
        end
    end

endmodule