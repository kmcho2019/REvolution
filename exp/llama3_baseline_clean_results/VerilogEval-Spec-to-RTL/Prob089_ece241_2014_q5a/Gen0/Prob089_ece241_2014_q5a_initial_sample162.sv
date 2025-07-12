module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [31:0] num = 32'd0; // Register to hold the input number
reg [31:0] two_comp = 32'd0; // Register to hold the 2's complement
reg [4:0] bit_count = 5'd0; // Counter to keep track of the number of bits received
reg start = 1'b0; // Flag to indicate if we have started receiving input
reg [31:0] shift_reg = 32'd0; // Shift register to output the 2's complement

always @(posedge clk or posedge areset) begin
    if (areset) begin
        num <= 32'd0;
        two_comp <= 32'd0;
        bit_count <= 5'd0;
        start <= 1'b0;
        shift_reg <= 32'd0;
        z <= 1'b0;
    end else begin
        if (~start) begin
            if (x) begin
                num <= {num[30:0], x};
                two_comp <= {two_comp[30:0], ~x};
                bit_count <= bit_count + 1;
                start <= 1'b1;
            end
        end else begin
            num <= {num[30:0], x};
            two_comp <= {two_comp[30:0], ~x};
            bit_count <= bit_count + 1;
        end
    end
end

always @(posedge clk) begin
    if (start && areset) begin
        if (bit_count == 32) begin
            shift_reg <= two_comp + 1;
        end
        if (shift_reg != 32'd0) begin
            z <= shift_reg[31];
            shift_reg <= shift_reg << 1;
            if (shift_reg == 32'd0) begin
                start <= 1'b0;
            end
        end
    end
end

endmodule