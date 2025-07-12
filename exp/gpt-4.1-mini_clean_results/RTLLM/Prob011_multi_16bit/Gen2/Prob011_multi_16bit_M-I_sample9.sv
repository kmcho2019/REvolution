module multi_16bit (
    input         clk,
    input         rst_n,
    input         start,
    input  [15:0] ain,
    input  [15:0] bin,
    output [31:0] yout,
    output        done
);

    reg [4:0]  i;         // shift count (0 to 17)
    reg        done_r;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] yout_r;

    wire active = start && (i < 17);

    // Shift count register and done flag logic with clock gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 0;
            done_r <= 0;
        end else begin
            if (start) begin
                if (i < 17)
                    i <= i + 1;
            end else begin
                i <= 0;
            end

            if (i == 16)
                done_r <= 1;
            else if (i == 17)
                done_r <= 0;
        end
    end

    // Shift and accumulate operation with clock gating and addition gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg  <= 16'b0;
            breg  <= 16'b0;
            yout_r <= 32'b0;
        end else if (start) begin
            if (i == 0) begin
                areg  <= ain;
                breg  <= bin;
                yout_r <= 32'b0;
            end else if (i > 0 && i < 17) begin
                if (areg[i-1])
                    yout_r <= yout_r + ({16'b0, breg} << (i-1));
            end
        end else begin
            areg  <= 16'b0;
            breg  <= 16'b0;
            yout_r <= 32'b0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule