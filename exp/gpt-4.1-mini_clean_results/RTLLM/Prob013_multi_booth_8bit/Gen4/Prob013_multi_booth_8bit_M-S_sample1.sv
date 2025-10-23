module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,      // multiplicand
    input  wire [7:0]  b,      // multiplier
    output reg  [15:0] p,      // product output (lower 16 bits)
    output reg         rdy      // ready signal
);

    reg signed [15:0] multiplicand;   // sign-extended multiplicand
    reg [15:0]        multiplier;     // sign-extended multiplier (unsigned because shifted indexing)
    reg signed [31:0] product_accum;  // 32-bit accumulator for product
    reg [4:0]         ctr;             // 5-bit counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};  // sign-extend multiplicand
            multiplier   <= {{8{b[7]}}, b};  // sign-extend multiplier (keep as unsigned for bit-indexing)
            product_accum <= 32'sd0;
            ctr <= 5'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 5'd16) begin
                if (multiplier[ctr])
                    product_accum <= product_accum + (multiplicand <<< ctr);
                ctr <= ctr + 1;
            end else begin
                p <= product_accum[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule