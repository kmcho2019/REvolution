module multi_16bit (
    input           clk,
    input           rst_n,
    input           start,
    input  [15:0]   ain,
    input  [15:0]   bin,
    output reg [31:0] yout,
    output reg      done
);

    reg [4:0] i;          // shift count register (0 to 17)
    reg [15:0] areg;      // multiplicand register
    reg [15:0] breg;      // multiplier register
    reg [31:0] yout_r;    // product accumulator

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 5'd0;
            done   <= 1'b0;
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else begin
            if (!start) begin
                i      <= 5'd0;
                done   <= 1'b0;
                yout_r <= 32'd0;
            end else if (i < 5'd17) begin
                i <= i + 5'd1;
                if (i == 5'd0) begin
                    areg   <= ain;
                    breg   <= bin;
                    yout_r <= 32'd0;
                end else if (i <= 5'd16) begin
                    // Check bit (i-1) of areg; if set, add shifted breg
                    if (areg[i-1])
                        yout_r <= yout_r + ( {16'd0, breg} << (i - 1) );
                    else
                        yout_r <= yout_r;
                end
            end

            // done flag logic
            if (i == 5'd16)
                done <= 1'b1;
            else if (i == 5'd17)
                done <= 1'b0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            yout <= 32'd0;
        else
            yout <= yout_r;
    end

endmodule