module multi_pipe_4bit #(
    parameter size = 4
)(
    input               clk,
    input               rst_n,
    input  [size-1:0]   mul_a,
    input  [size-1:0]   mul_b,
    output [2*size-1:0] mul_out
);

    // Internal signals
    reg  [2*size-1:0]   reg1;
    reg  [2*size-1:0]   reg2;
    wire [2*size-1:0]   partial_product [size];
    wire [2*size-1:0]   sum;

    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < size; i++) begin
            assign partial_product[i] = (mul_b[i]) ? (mul_a << i) : 'd0;
        end
    endgenerate

    // Calculate sum of partial products
    assign sum = partial_product[0] + partial_product[1] + partial_product[2] + partial_product[3];

    // Update registers on positive edge of clock or falling edge of reset
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg1 <= 'd0;
            reg2 <= 'd0;
            mul_out <= 'd0;
        end else begin
            reg1 <= sum;
            reg2 <= reg1;
            mul_out <= reg2;
        end
    end

endmodule