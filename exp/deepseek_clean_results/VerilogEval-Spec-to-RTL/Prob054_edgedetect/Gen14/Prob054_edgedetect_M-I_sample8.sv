module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg prev_in_valid = 1'b0;
    wire clk_gated = prev_in_valid ? clk : 1'b0;

    always @(posedge clk) begin
        // Detect when input changes to enable clock gating
        prev_in_valid <= (in != prev_in);
    end

    always @(posedge clk_gated) begin
        // Only update when inputs have changed
        prev_in <= in;
    end

    always @(posedge clk) begin
        // Edge detection remains combinational
        pedge <= in & ~prev_in;
    end

endmodule