module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg     done
);

    reg [4:0] i;              // shift count: 0 to 16
    reg [15:0] areg;          // multiplicand register
    reg [15:0] breg;          // multiplier register
    reg [31:0] product;       // product register (accumulator)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            product <= 32'd0;
            done <= 1'b0;
            yout <= 32'd0;
        end else begin
            if (!start) begin
                i <= 5'd0;
                done <= 1'b0;
                yout <= 32'd0;
                product <= 32'd0;
            end else if (i == 5'd0) begin
                // load multiplicand and multiplier at start
                areg <= ain;
                breg <= bin;
                product <= 32'd0;
                i <= 5'd1;
                done <= 1'b0;
            end else if (i <= 5'd16) begin
                // shift and accumulate
                if (areg[i-1])
                    product <= product + ( {16'd0, breg} << (i-1) );
                // increment count
                i <= i + 5'd1;
                if (i == 5'd16)
                    done <= 1'b1;
            end else begin
                // after finishing, hold done and product
                done <= 1'b0;  // as per spec, done reset after i=17 cycle, but not required here
            end

            yout <= product;
        end
    end

endmodule