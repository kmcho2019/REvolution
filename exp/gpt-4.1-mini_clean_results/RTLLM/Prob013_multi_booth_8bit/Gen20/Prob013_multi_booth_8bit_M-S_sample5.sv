module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,       // multiplier input
    input      [7:0]  b,       // multiplicand input
    output reg [15:0] p,       // product output
    output reg        rdy       // ready signal
);

    reg signed [15:0] multiplicand;
    reg signed [15:0] multiplier;
    reg signed [15:0] product;
    reg [4:0] ctr; // 0 to 16

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{b[7]}}, b}; // sign-extend multiplicand
            multiplier <= {{8{a[7]}}, a};   // sign-extend multiplier
            product <= 16'sd0;
            ctr <= 5'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (ctr < 5'd16) begin
            // On each cycle, check multiplier bit ctr
            if (multiplier[ctr])
                product <= product + multiplicand;

            multiplicand <= multiplicand <<< 1; // shift left arithmetic
            ctr <= ctr + 1;

            rdy <= 1'b0;
        end else if (ctr == 5'd16) begin
            p <= product;
            rdy <= 1'b1;
            ctr <= ctr + 1; // To stop incrementing further
        end else begin
            // Hold outputs stable after done
            rdy <= 1'b1;
        end
    end

endmodule