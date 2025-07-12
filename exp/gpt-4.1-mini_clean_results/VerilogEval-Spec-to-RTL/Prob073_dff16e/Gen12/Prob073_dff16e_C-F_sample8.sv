module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input   [15:0] d,
    output  reg [15:0] q
);

    // Byte enables for upper and lower bytes
    wire upper_en = byteena[1];
    wire lower_en = byteena[0];

    // Construct mask from byte enables to select which bytes update
    wire [15:0] mask = {
        (upper_en ? 8'hFF : 8'h00),
        (lower_en ? 8'hFF : 8'h00)
    };

    // Combine byte enables to generate a clock enable for the register update
    wire update_en = upper_en | lower_en;

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else if (update_en) begin
            // Update only enabled bytes using the mask, preserve others
            q <= (q & ~mask) | (d & mask);
        end
        // else no update, q holds its previous value
    end

endmodule