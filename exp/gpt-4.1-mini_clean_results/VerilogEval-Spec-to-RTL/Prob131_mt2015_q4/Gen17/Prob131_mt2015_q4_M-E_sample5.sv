// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: From waveform, B behaves as NOT(x XOR y), i.e., B_out = ~(x ^ y)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top module with pipeline registers for all submodule outputs before combining gates
module TopModule(
    input wire clk,
    input wire rst_n,
    input wire x,
    input wire y,
    output reg z
);

    wire a1_out, a2_out;
    wire b1_out, b2_out;

    // Instantiate two A modules
    A a1(.x(x), .y(y), .z(a1_out));
    A a2(.x(x), .y(y), .z(a2_out));

    // Instantiate two B modules
    B b1(.x(x), .y(y), .z(b1_out));
    B b2(.x(x), .y(y), .z(b2_out));

    // Registers to pipeline outputs of A and B
    reg a1_reg, a2_reg;
    reg b1_reg, b2_reg;

    // Registered versions of OR and AND outputs
    reg or_reg, and_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a1_reg <= 1'b0;
            a2_reg <= 1'b0;
            b1_reg <= 1'b0;
            b2_reg <= 1'b0;
            or_reg <= 1'b0;
            and_reg <= 1'b0;
            z <= 1'b0;
        end else begin
            // Pipeline submodule outputs
            a1_reg <= a1_out;
            b1_reg <= b1_out;
            a2_reg <= a2_out;
            b2_reg <= b2_out;

            // Combine registered outputs
            or_reg <= a1_reg | b1_reg;
            and_reg <= a2_reg & b2_reg;

            // Final XOR output
            z <= or_reg ^ and_reg;
        end
    end

endmodule