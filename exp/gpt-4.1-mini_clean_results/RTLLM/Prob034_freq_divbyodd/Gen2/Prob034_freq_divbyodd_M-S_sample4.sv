module freq_divbyodd #(parameter NUM_DIV = 5) (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Validate NUM_DIV is odd and >=3
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
        end
    end

    localparam WIDTH = $clog2(NUM_DIV);
    localparam HALF_DIV = NUM_DIV >> 1;  // floor(NUM_DIV/2)

    reg [WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end

            // Toggle clk_div at halfway count to create odd division
            if (cnt == HALF_DIV) begin
                clk_div <= ~clk_div;
            end
        end
    end

endmodule