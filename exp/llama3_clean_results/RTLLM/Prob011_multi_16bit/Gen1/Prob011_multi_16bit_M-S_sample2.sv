module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [4:0] i;  // shift count register with sufficient bit width
reg [15:0] areg;  // multiplicand register
reg [15:0] breg;  // multiplier register
reg [31:0] yout_r;  // product register with sufficient bit width
reg done_r;  // multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 5'd0;  // reset shift count register
        areg <= 16'd0;  // reset multiplicand register
        breg <= 16'd0;  // reset multiplier register
        yout_r <= 32'd0;  // reset product register
        done_r <= 1'b0;  // reset multiplication completion flag
    end else if (start) begin
        if (i == 5'd0) begin
            areg <= ain;  // load multiplicand
            breg <= bin;  // load multiplier
            yout_r <= 32'd0;  // reset product register
        end
        if (i < 5'd16) begin
            i <= i + 5'd1;  // increment shift count
            if (areg[15 - i] == 1'b1) begin
                yout_r <= yout_r + (breg << (i - 5'd1));  // accumulate product
            end
        end else if (i == 5'd16) begin
            i <= i + 5'd1;  // increment shift count for completion
        end
    end else begin
        i <= 5'd0;  // reset shift count register when start is low
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 1'b0;  // reset multiplication completion flag
    end else if (i == 5'd16) begin
        done_r <= 1'b1;  // set multiplication completion flag
    end else if (i == 5'd17) begin
        done_r <= 1'b0;  // reset multiplication completion flag after completion
    end
end

assign yout = yout_r;  // assign product register to output
assign done = done_r;  // assign multiplication completion flag to output

endmodule