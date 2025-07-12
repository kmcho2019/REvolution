module signal_generator (
    input            clk,
    input            rst_n,
    output reg [4:0] wave
);

    // Signed 2-bit delta: +1 or -1
    reg signed [1:0] delta;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave  <= 5'd0;
            delta <= 2'sd1; // start incrementing
        end else begin
            wave <= wave + delta;
            // Flip direction when boundaries are reached
            if (wave == 5'd31)
                delta <= -2'sd1;
            else if (wave == 5'd0)
                delta <= 2'sd1;
        end
    end

endmodule