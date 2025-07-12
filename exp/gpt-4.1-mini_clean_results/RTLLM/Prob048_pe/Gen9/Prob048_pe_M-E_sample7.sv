module pe (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  c
);

    wire [63:0] product;
    reg  [31:0] acc_next;

    assign product = a * b;

    always @(*) begin
        // Add lower 32 bits of product to current accumulator value
        {acc_next[31], acc_next[30:0]} = c + product[31:0];
        // Saturation logic:
        // If carry out from MSB addition is 1, saturate to max 32'hFFFFFFFF
        if (acc_next[31]) begin
            acc_next = 32'hFFFFFFFF;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= acc_next;
        end
    end

endmodule