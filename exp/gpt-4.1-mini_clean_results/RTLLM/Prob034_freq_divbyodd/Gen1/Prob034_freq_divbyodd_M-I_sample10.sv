module freq_divbyodd #(parameter NUM_DIV = 5) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Validate NUM_DIV is odd and >=3
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
        end
    end

    localparam WIDTH = $clog2(NUM_DIV);
    localparam HALF_DIV = NUM_DIV >> 1;  // Integer division by 2

    reg [WIDTH-1:0] cnt1;
    reg [WIDTH-1:0] cnt2;
    reg clk_div1;
    reg clk_div2;

    // Counter and clk_div1 toggling on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1    <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
            end

            // Toggle clk_div1 at cnt1 == HALF_DIV to create half period phase
            if (cnt1 == HALF_DIV) begin
                clk_div1 <= ~clk_div1;
            end
        end
    end

    // Counter and clk_div2 toggling on negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2    <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
            end

            // Toggle clk_div2 at cnt2 == HALF_DIV to stagger toggling
            if (cnt2 == HALF_DIV) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end

    // Output clock is OR of clk_div1 and clk_div2, producing the divided clock
    assign clk_div = clk_div1 | clk_div2;

endmodule