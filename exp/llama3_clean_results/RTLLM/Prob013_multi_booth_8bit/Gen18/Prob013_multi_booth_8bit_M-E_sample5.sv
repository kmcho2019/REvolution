module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Pipeline registers
reg [15:0] multiplicand_reg1;
reg [15:0] multiplicand_reg2;
reg [15:0] multiplicand_reg3;
reg [15:0] multiplier_reg;
reg [15:0] product_reg1;
reg [15:0] product_reg2;
reg [15:0] product_reg3;
reg [4:0] ctr_reg1;
reg [4:0] ctr_reg2;
reg [4:0] ctr_reg3;

// Internal signals
reg start;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset logic
        multiplicand_reg1 <= 0;
        multiplicand_reg2 <= 0;
        multiplicand_reg3 <= 0;
        multiplier_reg <= 0;
        product_reg1 <= 0;
        product_reg2 <= 0;
        product_reg3 <= 0;
        ctr_reg1 <= 0;
        ctr_reg2 <= 0;
        ctr_reg3 <= 0;
        start <= 0;
        rdy <= 0;
    end else begin
        // Pipeline stage 1: Initialization
        multiplicand_reg1 <= (start) ? {{8{b[7]}}, b} : multiplicand_reg1;
        multiplier_reg <= (start) ? {{8{a[7]}}, a} : multiplier_reg;
        ctr_reg1 <= (start) ? 0 : ctr_reg1;
        start <= (start) ? 1 : (a != 0 && b != 0);

        // Pipeline stage 2: Multiplicand Shifting
        multiplicand_reg2 <= multiplicand_reg1 << 1;
        product_reg1 <= product_reg1;
        ctr_reg2 <= ctr_reg1 + 1;

        // Pipeline stage 3: Multiplication and Accumulation
        if (multiplier_reg[ctr_reg2]) begin
            product_reg2 <= product_reg1 + multiplicand_reg2;
        end else begin
            product_reg2 <= product_reg1;
        end
        multiplicand_reg3 <= multiplicand_reg2;
        ctr_reg3 <= ctr_reg2;

        // Pipeline stage 4: Output
        p <= product_reg2;
        rdy <= (ctr_reg3 == 16);
    end
end

endmodule