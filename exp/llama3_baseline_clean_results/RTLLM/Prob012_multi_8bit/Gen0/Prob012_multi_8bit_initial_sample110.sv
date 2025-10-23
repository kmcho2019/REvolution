module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
    );

reg [15:0] prod_reg;
reg [7:0] A_shifted;
reg [7:0] B_reg;
reg [3:0] counter;

always @(posedge B) begin
    prod_reg <= 16'd0;
    A_shifted <= A;
    B_reg <= B;
    counter <= 8'd0;
end

always @(posedge B_reg[0] or posedge counter) begin
    if (counter < 8) begin
        if (B_reg[7 - counter] == 1'b1) begin
            prod_reg <= prod_reg + (A_shifted << counter);
        end
        A_shifted <= A_shifted << 1;
        B_reg <= {1'b0, B_reg[7:1]};
        counter <= counter + 1'b1;
    end else begin
        product <= prod_reg;
    end
end

assign product = prod_reg;

endmodule