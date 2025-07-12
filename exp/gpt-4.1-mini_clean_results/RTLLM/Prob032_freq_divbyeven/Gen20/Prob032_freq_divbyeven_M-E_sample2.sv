module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and <= 16
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time assertions
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Parameter NUM_DIV must be even. Got: %0d", NUM_DIV);
        end
        if (NUM_DIV > 16) begin
            $error("Parameter NUM_DIV must be <= 16 to fit 4-bit counter. Got: %0d", NUM_DIV);
        end
    end

    localparam integer HALF_DIV = NUM_DIV >> 1;

    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt     <= 4'd0;
                clk_div <= ~clk_div; // Toggle output every half cycle
            end else begin
                cnt <= cnt + 4'd1;
            end
        end
    end

endmodule