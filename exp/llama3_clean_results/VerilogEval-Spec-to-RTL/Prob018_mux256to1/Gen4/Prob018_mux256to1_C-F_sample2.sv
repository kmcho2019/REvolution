module TopModule(
    input [255:0] in, // 256-bit input vector
    input [7:0] sel, // 8-bit select input
    output reg out // 1-bit output
);

    always @(*) begin
        out = in[sel]; // Assign the selected bit to the output using direct indexing
    end

    // Add input and output registers to improve timing and reduce power consumption
    reg [255:0] in_reg;
    reg [7:0] sel_reg;
    reg out_reg;

    always @(posedge clk) begin
        in_reg <= in;
        sel_reg <= sel;
        out_reg <= out;
    end

    // Use the registered inputs and outputs
    assign out = in_reg[sel_reg];

endmodule