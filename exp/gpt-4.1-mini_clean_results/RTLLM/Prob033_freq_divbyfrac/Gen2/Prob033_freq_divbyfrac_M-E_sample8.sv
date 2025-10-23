module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam CNT_MAX = 7; // counts from 0 to 6

    reg [2:0] cnt;

    // Counter increments on rising edge, resets on rst_n low
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Signal that toggles on posedge clk at count == 0 or 4
    // Generates a 3.5 division base clock rising edge
    reg pos_edge_div;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pos_edge_div <= 1'b0;
        else if (cnt == 3'd0 || cnt == 3'd4)
            pos_edge_div <= ~pos_edge_div;
    end

    // Signal that toggles on negedge clk at count == 1 or 5
    // This introduces the half-cycle phase shift
    reg neg_edge_div;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            neg_edge_div <= 1'b0;
        else if (cnt == 3'd1 || cnt == 3'd5)
            neg_edge_div <= ~neg_edge_div;
    end

    // Combine both edges to create the final fractional divided clock
    assign clk_div = pos_edge_div | neg_edge_div;

endmodule