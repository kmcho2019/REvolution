module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    // Gated clocks for each byte segment
    wire upper_clk = clk & byteena[1];
    wire lower_clk = clk & byteena[0];

    // Upper byte register bank
    reg [7:0] upper_reg;
    always @(posedge upper_clk) begin
        if (!resetn) upper_reg <= 8'b0;
        else upper_reg <= d[15:8];
    end

    // Lower byte register bank
    reg [7:0] lower_reg;
    always @(posedge lower_clk) begin
        if (!resetn) lower_reg <= 8'b0;
        else lower_reg <= d[7:0];
    end

    // Output assignment
    assign q = {upper_reg, lower_reg};

endmodule