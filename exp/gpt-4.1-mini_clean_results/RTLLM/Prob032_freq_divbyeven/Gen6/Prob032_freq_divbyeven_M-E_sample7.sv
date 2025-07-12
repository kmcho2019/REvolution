module freq_diveven #(
    parameter NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt     <= 4'd0;
                clk_div <= ~clk_div; // Toggle at end of full count
            end else begin
                cnt <= cnt + 1;
                if (cnt == (NUM_DIV/2 - 1)) begin
                    clk_div <= ~clk_div; // Toggle at half count
                end
            end
        end
    end

endmodule