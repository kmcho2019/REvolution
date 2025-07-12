module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg       done
);

    reg [4:0] i;            // count cycles (0 to 17)
    reg [15:0] areg;        // hold multiplicand
    reg [15:0] breg;        // hold multiplier
    reg [31:0] product;     // product accumulator

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i       <= 5'd0;
            areg    <= 16'd0;
            breg    <= 16'd0;
            product <= 32'd0;
            yout    <= 32'd0;
            done    <= 1'b0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    // Load inputs and clear product
                    areg    <= ain;
                    breg    <= bin;
                    product <= 32'd0;
                    done    <= 1'b0;
                    i       <= i + 1;
                end else if (i <= 5'd16) begin
                    // If bit (i-1) of multiplicand is 1, add multiplier shifted by (i-1)
                    if (areg[i-1])
                        product <= product + ( {16'd0, breg} << (i - 1) );
                    else
                        product <= product;
                    i <= i + 1;
                end else begin
                    // Multiplication done at i=17
                    yout <= product;
                    done <= 1'b1;
                    // Hold i at 17 until start deasserted
                end
            end else begin
                // Clear registers when start is low
                i       <= 5'd0;
                areg    <= 16'd0;
                breg    <= 16'd0;
                product <= 32'd0;
                yout    <= 32'd0;
                done    <= 1'b0;
            end
        end
    end

endmodule