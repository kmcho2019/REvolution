module multi_16bit (
    input          clk,
    input          rst_n,    // active-low reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg      done
);

    reg [4:0]  i;         // shift count (0 to 17)
    reg [15:0] areg;      // multiplicand register
    reg [15:0] breg;      // multiplier register
    reg [31:0] yout_r;    // product register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 5'd0;
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
            done   <= 1'b0;
            yout   <= 32'd0;
        end else begin
            if (!start) begin
                // Reset shift count and done flag when start is low
                i    <= 5'd0;
                done <= 1'b0;
                yout <= yout_r; // hold current output
            end else if (i == 5'd0) begin
                // Load inputs at start of operation
                i      <= 5'd1;
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'd0;
                done   <= 1'b0;
            end else if (i >= 1 && i <= 16) begin
                // For each bit position i-1, add shifted multiplier if bit is set
                if (areg[i-1])
                    yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
                else
                    yout_r <= yout_r;

                i <= i + 5'd1;
                done <= (i == 5'd16) ? 1'b1 : 1'b0;
                yout <= yout_r;
            end else if (i == 5'd17) begin
                // Clear done and wait for next start
                i    <= 5'd0;
                done <= 1'b0;
                yout <= yout_r;
            end else begin
                // Hold values if unexpected state
                i    <= i;
                done <= done;
                yout <= yout_r;
            end
        end
    end

endmodule