module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Define the 4-bit Radix-4 Booth multiplier module
module booth_4bit(
    input [3:0] a,
    input [3:0] b,
    output reg [7:0] p
);
    reg [7:0] multiplicand;
    reg [7:0] product;
    reg [1:0] ctr;

    always @(posedge clk) begin
        if (reset) begin
            multiplicand <= {4{b[3]}, b};
            product <= 0;
            ctr <= 0;
        end else begin
            if (ctr < 4) begin
                if (a[ctr] == 1) begin
                    product <= product + multiplicand;
                end
                multiplicand <= multiplicand << 1;
                ctr <= ctr + 1;
            end
        end
    end

    assign p = product;
endmodule

// Instantiate two 4-bit Radix-4 Booth multipliers
booth_4bit u1(
   .a(a[7:4]),
   .b(b),
   .p(p_high)
);

booth_4bit u2(
   .a(a[3:0]),
   .b(b),
   .p(p_low)
);

// Define the carry-save adder module
module csa(
    input [7:0] a,
    input [7:0] b,
    output reg [8:0] sum
);
    reg [8:0] s;

    always @(posedge clk) begin
        if (reset) begin
            s <= 0;
        end else begin
            s <= a + b;
        end
    end

    assign sum = s;
endmodule

// Instantiate the carry-save adder
csa u3(
   .a(p_high),
   .b(p_low),
   .sum(p)
);

// Define the control logic
reg [1:0] state;
reg [15:0] p_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        p_reg <= 0;
        rdy <= 0;
    end else begin
        case (state)
            0: begin
                // Initialize the multipliers
                state <= 1;
            end
            1: begin
                // Wait for the multipliers to finish
                if (u1.ctr == 4 && u2.ctr == 4) begin
                    state <= 2;
                end
            end
            2: begin
                // Combine the partial products using the carry-save adder
                p_reg <= u3.sum;
                state <= 3;
            end
            3: begin
                // Output the final product
                p <= p_reg;
                rdy <= 1;
            end
        endcase
    end
end

endmodule