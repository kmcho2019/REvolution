module multi_16bit (
    input         clk,
    input         rst_n,
    input         start,
    input  [15:0] ain,
    input  [15:0] bin,
    output [31:0] yout,
    output        done
);

    reg [4:0]  i;        // Shift count: 0 to 16
    reg        done_r;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] yout_r;

    // Shift count and done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 0;
            done_r <= 0;
        end else if (start) begin
            if (i < 16)
                i <= i + 1;
            if (i == 15)
                done_r <= 1;
        end else begin
            i      <= 0;
            done_r <= 0;
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 0;
            breg   <= 0;
            yout_r <= 0;
        end else if (start) begin
            if (i == 0) begin
                areg   <= ain;
                breg   <= bin;
                yout_r <= 0;
            end else if (i <= 16) begin
                if (areg[i-1])
                    yout_r <= yout_r + (breg << (i - 1));
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule