module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg signed [4:0] step;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            step <= 5'sd1;  // start incrementing by +1
        end else begin
            // Update wave by adding step
            wave <= wave + step;

            // If wave reaches maximum, reverse direction
            if (wave == 5'd31)
                step <= -5'sd1;
            // If wave reaches minimum, reverse direction
            else if (wave == 5'd0)
                step <= 5'sd1;
        end
    end

endmodule