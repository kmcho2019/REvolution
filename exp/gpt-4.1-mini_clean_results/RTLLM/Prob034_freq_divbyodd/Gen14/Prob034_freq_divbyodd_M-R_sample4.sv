module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low reset
    output reg  clk_div
);

    // Check NUM_DIV is odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = (NUM_DIV - 1) >> 1; // (NUM_DIV-1)/2

    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt_pos;  // counts on posedge clk
    reg [CNT_WIDTH-1:0] cnt_neg;  // counts on negedge clk

    reg toggle_req; // request to toggle clk_div on next posedge clk

    // Counter cnt_pos increments on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 0;
            toggle_req <= 1'b0;
            clk_div <= 1'b0;
        end else begin
            if (cnt_pos == NUM_DIV - 1)
                cnt_pos <= 0;
            else
                cnt_pos <= cnt_pos + 1;

            // Toggle clk_div if toggle request flag is set
            if (toggle_req) begin
                clk_div <= ~clk_div;
                toggle_req <= 1'b0; // clear toggle request after toggling
            end
        end
    end

    // Counter cnt_neg increments on negedge clk
    // Generates toggle request flag when half_div is reached on either edge counter
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 0;
        end else begin
            if (cnt_neg == NUM_DIV - 1)
                cnt_neg <= 0;
            else
                cnt_neg <= cnt_neg + 1;

            // When either counter reaches HALF_DIV, request a toggle on next posedge clk
            if ((cnt_neg == HALF_DIV) || (cnt_pos == HALF_DIV)) begin
                toggle_req <= 1'b1;
            end
        end
    end

endmodule