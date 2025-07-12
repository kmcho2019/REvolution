module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and <= 16
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameter checks at elaboration time
    initial begin
        if (NUM_DIV < 2 || (NUM_DIV % 2) != 0) begin
            $error("NUM_DIV (%0d) must be an even number >= 2", NUM_DIV);
        end
        if (NUM_DIV > 16) begin
            $error("NUM_DIV (%0d) must fit in 4-bit counter (max 16)", NUM_DIV);
        end
    end

    localparam integer COUNT_MAX    = NUM_DIV - 1;
    localparam integer TOGGLE_POINT = (NUM_DIV >> 1) - 1;  // NUM_DIV/2 - 1

    reg [3:0] cnt, cnt_next;
    reg       clk_div_reg, clk_div_next;

    // Next-state combinational logic
    always @* begin
        // Default assignments: hold current state
        cnt_next     = cnt;
        clk_div_next = clk_div_reg;

        if (cnt == COUNT_MAX)
            cnt_next = 4'd0;
        else
            cnt_next = cnt + 1'b1;

        if (cnt == TOGGLE_POINT)
            clk_div_next = ~clk_div_reg;
    end

    // Sequential logic for state update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt         <= 4'd0;
            clk_div_reg <= 1'b0;
        end else begin
            cnt         <= cnt_next;
            clk_div_reg <= clk_div_next;
        end
    end

    assign clk_div = clk_div_reg;

endmodule