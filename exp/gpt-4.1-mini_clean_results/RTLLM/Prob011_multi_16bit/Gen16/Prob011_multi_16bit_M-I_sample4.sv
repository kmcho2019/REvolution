module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]  i;           // shift count: 0 to 17
    reg [15:0] areg;        // multiplicand register
    reg [15:0] breg;        // multiplier register
    reg [31:0] yout_r;      // product register
    reg        done_r;      // done flag register

    // Shift count register logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (start && (i < 5'd17))
            i <= i + 5'd1;
        else if (!start)
            i <= 5'd0;
    end

    // Done flag logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
        else if (i == 5'd17)
            done_r <= 1'b0;
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Load inputs
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'd0;
            end else if ((i > 0) && (i < 5'd17)) begin
                // If bit (i-1) of areg is 1, accumulate shifted breg
                if (areg[i-1])
                    yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
                else
                    yout_r <= yout_r; // no change
            end
        end else begin
            // If not start, reset product registers (optional)
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule