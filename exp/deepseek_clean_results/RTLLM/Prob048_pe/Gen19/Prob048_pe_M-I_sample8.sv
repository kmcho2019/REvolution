module pe #(
    parameter WIDTH = 32
) (
    input wire clk,
    input wire rst,
    input wire en,        // Enable signal for power reduction
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c
);

    // Pipeline registers
    reg signed [WIDTH-1:0] a_reg, b_reg;
    reg signed [2*WIDTH-1:0] product_reg;
    reg signed [WIDTH-1:0] acc_reg;

    // Stage 1: Multiplication (combinational)
    wire signed [2*WIDTH-1:0] product = a_reg * b_reg;

    // Stage 2: Accumulation (combinational)
    wire signed [WIDTH-1:0] accumulated = acc_reg + product[WIDTH-1:0];

    always @(posedge clk) begin
        if (rst) begin
            // Reset all pipeline registers
            a_reg <= {WIDTH{1'b0}};
            b_reg <= {WIDTH{1'b0}};
            product_reg <= {(2*WIDTH){1'b0}};
            acc_reg <= {WIDTH{1'b0}};
            c <= {WIDTH{1'b0}};
        end else if (en) begin
            // Pipeline stage 1: Register inputs and multiply
            a_reg <= a;
            b_reg <= b;
            
            // Pipeline stage 2: Register product and accumulate
            product_reg <= product;
            acc_reg <= accumulated;
            
            // Output registered accumulation result
            c <= acc_reg;
        end
        // When disabled, registers maintain their values (no power consumption)
    end

    // Optional: Overflow detection
    // wire overflow = (accumulated > (2**(WIDTH-1)-1)) || 
    //                (accumulated < -(2**(WIDTH-1)));

endmodule