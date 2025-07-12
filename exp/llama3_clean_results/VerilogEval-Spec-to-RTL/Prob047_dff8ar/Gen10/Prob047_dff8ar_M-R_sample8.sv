module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg;

    // Reset logic
    always @(posedge areset) begin
        q_reg <= 8'b0;
    end

    // Clock edge logic
    always @(posedge clk) begin
        q_reg <= d;
    end

    // Assign output
    assign q = q_reg;

endmodule