module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] shift_reg; // Assuming a maximum input length of 32 bits
reg [4:0] bit_counter; // Counter to track the number of bits received
reg first_one_detected;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg <= 32'd0;
        bit_counter <= 5'd0;
        first_one_detected <= 1'b0;
        z <= 1'b0;
    end else begin
        // Shift the input bit into the register
        shift_reg <= {shift_reg[30:0], x};

        // Increment the bit counter
        bit_counter <= bit_counter + 1;

        // Detect the first '1'
        if (~first_one_detected && x) begin
            first_one_detected <= 1'b1;
        end

        // Invert subsequent bits if the first '1' has been detected
        if (first_one_detected) begin
            z <= ~shift_reg[31];
        end else begin
            z <= 1'b0;
        end
    end
end

endmodule