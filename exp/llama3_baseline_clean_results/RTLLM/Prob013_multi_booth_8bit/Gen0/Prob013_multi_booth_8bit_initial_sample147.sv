module multi_booth_8bit(
    input  logic clk,
    input  logic reset,
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [15:0] p,
    output logic rdy
);

logic [15:0] multiplier;
logic [15:0] multiplicand;
logic [15:0] product;
logic [4:0] ctr;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        product <= 0;
        ctr <= 0;
        rdy <= 0;
    end else if (ctr < 16) begin
        multiplicand <= multiplicand << 1;
        if (multiplier[ctr] == 1'b1) begin
            product <= product + multiplicand;
        end
        ctr <= ctr + 1;
        if (ctr == 16) begin
            rdy <= 1'b1;
        end
    end
end

always_comb begin
    p = product;
end

endmodule