module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [4:0] i; // shift count register
reg [15:0] areg; // multiplicand register
reg [15:0] breg; // multiplier register
reg [31:0] yout_r; // product register
reg done_r; // multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
    end else if (start) begin // start signal is active
        if (i < 17) begin
            i <= i + 1;
        end
        if (i == 0) begin // store multiplicand and multiplier
            areg <= ain;
            breg <= bin;
        end else if (i > 0 && i < 17) begin
            if (areg[i-1] == 1'b1) begin // accumulate product
                yout_r <= yout_r + (breg << (i-1));
            end
        end
    end else begin // start signal is inactive
        i <= 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        done_r <= 0;
    end else if (i == 16) begin // multiplication completion
        done_r <= 1'b1;
    end else if (i == 17) begin // reset completion flag
        done_r <= 0;
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule