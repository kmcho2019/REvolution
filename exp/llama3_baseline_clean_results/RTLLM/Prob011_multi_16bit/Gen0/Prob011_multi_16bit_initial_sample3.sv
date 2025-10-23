module multi_16bit(
    input clk, 
    input rst_n, 
    input start, 
    input [15:0] ain, 
    input [15:0] bin, 
    output [31:0] yout, 
    output done
);

reg [15:0] areg;  // multiplicand register
reg [15:0] breg;  // multiplier register
reg [31:0] yout_r;  // product register
reg [4:0] i;  // shift count register
reg done_r;  // multiplication completion flag

// update shift count register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 5'b0;
    end else if (start && (i < 16)) begin
        i <= i + 1;
    end else if (!start) begin
        i <= 5'b0;
    end
end

// update multiplication completion flag
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 1'b0;
    end else if (i == 16) begin
        done_r <= 1'b1;
    end else if (i == 17) begin
        done_r <= 1'b0;
    end
end

// shift and accumulate operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 16'b0;
        breg <= 16'b0;
        yout_r <= 32'b0;
    end else if (start) begin
        if (i == 0) begin
            areg <= ain;
            breg <= bin;
            yout_r <= 32'b0;
        end else if ((i > 0) && (i < 17)) begin
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