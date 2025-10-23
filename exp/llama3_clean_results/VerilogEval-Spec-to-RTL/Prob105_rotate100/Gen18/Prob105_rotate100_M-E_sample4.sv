module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Handle sequential logic in a single always block
always @(posedge clk) begin
    if (load) begin
        // Load the shift register with data
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: begin
                // Rotate right by one bit
                reg [99:0] temp;
                temp[0] = q_reg[99];
                temp[99:1] = q_reg[98:0];
                q_reg <= temp;
            end
            2'b10: begin
                // Rotate left by one bit
                reg [99:0] temp;
                temp[99] = q_reg[0];
                temp[98:0] = q_reg[99:1];
                q_reg <= temp;
            end
            default: q_reg <= q_reg; // No rotation
        endcase
    end
end

// Directly update the output q
assign q = q_reg;

endmodule