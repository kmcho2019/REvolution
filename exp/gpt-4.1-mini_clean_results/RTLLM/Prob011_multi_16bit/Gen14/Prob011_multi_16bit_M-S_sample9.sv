module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg      done
);

    reg [4:0] i;             // shift count (0 to 16)
    reg [15:0] areg;         // multiplicand register
    reg [15:0] breg;         // multiplier register
    reg [31:0] yout_r;       // product register

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
                // When start is low, reset shift counter and done flag
                i    <= 5'd0;
                done <= 1'b0;
                yout <= yout_r; // keep output stable
            end else if (i == 5'd0) begin
                // On start (first cycle with start high), load inputs
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'd0;
                i      <= 5'd1;
                done   <= 1'b0;
                yout   <= 32'd0;
            end else if (i < 5'd17) begin
                // For shift counts 1 to 16, check bit (i-1) of areg and accumulate
                if (areg[i-1]) begin
                    yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
                end
                i <= i + 5'd1;

                // At i==16, done is asserted next cycle (i==17)
                if (i == 5'd16)
                    done <= 1'b1;
                else
                    done <= 1'b0;

                yout <= yout_r;
            end else if (i == 5'd17) begin
                // Reset done flag after done cycle
                done <= 1'b0;
                yout <= yout_r;
                i <= 5'd0; // ready for next start
            end else begin
                // Default case to handle unexpected i values
                i <= 5'd0;
                done <= 1'b0;
                yout <= yout_r;
            end
        end
    end

endmodule