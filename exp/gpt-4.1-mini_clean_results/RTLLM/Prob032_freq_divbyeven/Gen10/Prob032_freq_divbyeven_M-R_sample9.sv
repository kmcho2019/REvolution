module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    localparam integer HALF_DIV = NUM_DIV >> 1;

    reg [3:0] cnt;
    wire toggle_pulse;

    // Counter process: increments and generates toggle pulse at HALF_DIV - 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
        end else if (cnt == HALF_DIV - 1) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end

    // Generate toggle pulse when counter reaches HALF_DIV-1
    assign toggle_pulse = (cnt == HALF_DIV - 1);

    // clk_div toggles on toggle_pulse synchronous to clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div <= 0;
        end else if (toggle_pulse) begin
            clk_div <= ~clk_div;
        end
    end

endmodule