module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg        done
);

    reg [4:0] i;               // shift count 0..17
    reg [15:0] areg;           // multiplicand stored at i=0
    reg [15:0] multiplicand;   // local copy of ain for bit test
    reg [15:0] breg;           // multiplier stored at i=0

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    // Load multiplicand and multiplier at start
                    areg <= ain;
                    breg <= bin;
                    yout <= 32'd0;
                    done <= 1'b0;
                    i <= 5'd1;
                end else if (i >= 5'd1 && i <= 5'd16) begin
                    // For each bit of multiplicand, add shifted multiplier if bit is 1
                    if (areg[i-1]) begin
                        yout <= yout + ( {16'd0, breg} << (i-1) );
                    end else begin
                        yout <= yout;
                    end
                    i <= i + 5'd1;
                    done <= 1'b0;
                end else if (i == 5'd17) begin
                    // Complete operation
                    done <= 1'b1;
                    i <= 5'd0;
                end else begin
                    // Default hold
                    i <= i;
                    done <= 1'b0;
                end
            end else begin
                // Reset counter and done flag when start is deasserted
                i <= 5'd0;
                done <= 1'b0;
                yout <= yout;
                areg <= areg;
                breg <= breg;
            end
        end
    end

endmodule