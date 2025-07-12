module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [4:0] i;  // shift count register
reg [31:0] areg;  // multiplicand register
reg [31:0] breg;  // multiplier register
reg [31:0] yout_r;  // product register
reg done_r;  // multiplication completion flag

// update shift count register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 5'd0;
    end else if (start && i < 5'd16) begin
        i <= i + 1;
    end else if (!start) begin
        i <= 5'd0;
    end
end

// update multiplication completion flag
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        done_r <= 1'd0;
    end else if (i == 5'd16) begin
        done_r <= 1'd1;
    end else if (i == 5'd17) begin
        done_r <= 1'd0;
    end
end

// shift and accumulate operation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        areg <= 32'd0;
        breg <= 32'd0;
        yout_r <= 32'd0;
    end else if (start) begin
        if (i == 5'd0) begin
            areg <= {16'd0, ain};
            breg <= {16'd0, bin};
            yout_r <= 32'd0;
        end else if (i > 5'd0 && i < 5'd17) begin
            if (areg[i-1]) begin
                yout_r <= yout_r + (breg << (i-1));
            end
        end
    end
end

// output assignment
assign yout = yout_r;
assign done = done_r;

endmodule