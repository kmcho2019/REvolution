module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Internal registers
    reg signed [31:0] acc_reg;
    
    // Continuous assignments
    wire signed [63:0] product = a * b;
    wire signed [31:0] next_acc = rst ? 32'd0 : (acc_reg + product[31:0]);
    
    // Output assignment
    assign c = acc_reg;
    
    // Synchronous update
    always @(posedge clk) begin
        acc_reg <= next_acc;
    end

endmodule