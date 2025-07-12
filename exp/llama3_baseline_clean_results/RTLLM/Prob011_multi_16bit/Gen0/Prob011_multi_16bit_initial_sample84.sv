module multi_16bit (
    input clk, 
    input rst_n, 
    input start, 
    input [15:0] ain, 
    input [15:0] bin, 
    output reg [31:0] yout, 
    output reg done
);

reg [4:0] i;  // shift count register
reg [31:0] yout_r;  // product register
reg [15:0] areg;  // multiplicand register
reg [15:0] breg;  // multiplier register
reg done_r;  // multiplication completion flag

// Data bit control
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 5'd0;
    end else if (start) begin
        if (i < 16) begin
            i <= i + 1;
        end else begin
            i <= 5'd0;
        end
    end else begin
        i <= 5'd0;
    end
end

// Multiplication completion flag generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        done_r <= 1'd0;
    end else if (i == 16) begin
        done_r <= 1'd1;
    end else if (i == 17) begin
        done_r <= 1'd0;
    end else begin
        done_r <= done_r;
    end
end

// Shift and accumulate operation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
    end else if (start) begin
        if (i == 0) begin
            areg <= ain;
            breg <= bin;
            yout_r <= 32'd0;
        end else if (i > 0 && i < 17) begin
            if (areg[i-1]) begin
                yout_r <= yout_r + (breg << (i-1));
            end
        end
    end
end

// Output assignment
always @(*) begin
    yout = yout_r;
    done = done_r;
end

endmodule