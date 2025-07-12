module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] count;  // Counter to keep track of number of bits
reg [31:0] sum;    // Accumulator to calculate the 2's complement
reg [31:0] out_reg; // Register to store the current output

always @(posedge clk or posedge areset) begin
    if (areset) begin
        count <= 0;
        sum <= 0;
        out_reg <= 0;
    end else begin
        if (count == 0) begin
            sum <= 0;
            out_reg <= 0;
        end else begin
            if (x) begin
                sum <= sum + (1 << (count - 1));
            end
            if (count == 1) begin
                out_reg <= ~(sum) + 1;
            end
        end
        count <= count + 1;
    end
end

always @(posedge clk) begin
    if (count > 1) begin
        z <= out_reg[0];
        out_reg <= out_reg >> 1;
    end else begin
        z <= 1'b0;
    end
end

endmodule