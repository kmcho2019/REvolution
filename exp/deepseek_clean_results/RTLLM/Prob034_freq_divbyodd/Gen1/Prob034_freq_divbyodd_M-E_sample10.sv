module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    reg [31:0] counter;
    reg toggle1, toggle2;
    wire phase_shifted_clk;
    localparam HALF_DIV = (NUM_DIV - 1) / 2;

    // Create 180° phase shifted clock
    assign phase_shifted_clk = ~clk;

    // Single counter for both edges
    always @(posedge clk or posedge phase_shifted_clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            toggle1 <= 0;
            toggle2 <= 0;
        end else begin
            if (counter == NUM_DIV - 1) begin
                counter <= 0;
                toggle1 <= ~toggle1;
            end else begin
                counter <= counter + 1;
                if (counter == HALF_DIV - 1)
                    toggle2 <= ~toggle2;
            end
        end
    end

    // Combine toggles with XOR to create final output
    assign clk_div = toggle1 ^ toggle2;

endmodule