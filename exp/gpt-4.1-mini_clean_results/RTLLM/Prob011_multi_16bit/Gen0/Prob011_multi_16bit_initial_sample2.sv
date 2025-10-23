module multi_16bit (
    input             clk,
    input             rst_n,
    input             start,
    input      [15:0] ain,
    input      [15:0] bin,
    output reg [31:0] yout,
    output            done
);

// Internal registers
reg [4:0]  i;         // shift count: needs to count up to 17, 5 bits enough
reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg        done_r;

// Shift count register logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        i <= 5'd0;
    else if (start) begin
        if (i < 5'd17)
            i <= i + 5'd1;
        else
            i <= i;
    end else
        i <= 5'd0;
end

// Multiplication completion flag logic
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
            areg   <= ain;
            breg   <= bin;
            yout_r <= 32'd0;
        end else if ((i > 5'd0) && (i < 5'd17)) begin
            // check bit i-1 of areg
            if (areg[i-1])
                yout_r <= yout_r + ( {16'd0,breg} << (i-1) );
            else
                yout_r <= yout_r;
        end
    end
end

// Output assignment
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        yout <= 32'd0;
    else
        yout <= yout_r;
end

// Output done flag
assign done = done_r;

endmodule