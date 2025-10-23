module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    reg [15:0] q_reg;

    // Create write mask based on byte enables
    wire [15:0] write_mask = {
        {8{byteena[1]}},  // Upper byte mask
        {8{byteena[0]}}   // Lower byte mask
    };

    always @(posedge clk) begin
        if (!resetn) begin
            q_reg <= 16'b0;
        end else begin
            // Apply byte-wise write enable using bitwise operations
            q_reg <= (d & write_mask) | (q_reg & ~write_mask);
        end
    end

    assign q = q_reg;

endmodule