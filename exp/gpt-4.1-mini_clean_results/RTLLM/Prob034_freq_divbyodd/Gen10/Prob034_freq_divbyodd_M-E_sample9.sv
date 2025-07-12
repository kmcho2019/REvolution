module freq_divbyodd #(
    parameter integer NUM_DIV = 5 // Must be odd
)(
    input  wire clk,
    input  wire rst_n,   // Active low reset
    output reg  clk_div  // Divided clock output
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer TOGGLE_POINT1 = (NUM_DIV - 1) >> 1; // (NUM_DIV-1)/2
    localparam integer TOGGLE_POINT2 = NUM_DIV - 1;

    // Width of the counter
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == TOGGLE_POINT2) begin
                cnt <= 0;
                clk_div <= ~clk_div; // Toggle output clock at end of cycle
            end else begin
                cnt <= cnt + 1;
                if (cnt == TOGGLE_POINT1) begin
                    clk_div <= ~clk_div; // Toggle output clock at mid count
                end
            end
        end
    end

endmodule