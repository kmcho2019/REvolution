module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [4:0] i; // 5-bit shift count register
reg [15:0] areg; // 16-bit multiplicand register
reg [15:0] breg; // 16-bit multiplier register
reg [31:0] yout_r; // 32-bit product register
reg done_r; // multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // reset condition
        i <= 0;
        done_r <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
    end else if (start) begin // start signal active
        if (i == 0) begin // initialize registers
            areg <= ain;
            breg <= bin;
            yout_r <= 0;
        end
        if (i < 16) begin // shift and accumulate operation
            if (areg[i]) begin // if bit at position i is high
                yout_r <= yout_r + (breg << i);
            end
            i <= i + 1;
        end else if (i == 16) begin // multiplication completion
            done_r <= 1;
        end else if (i == 17) begin // reset multiplication completion flag
            done_r <= 0;
            i <= 0;
        end
    end else begin // start signal inactive
        i <= 0;
    end
end

always @(posedge clk) begin
    yout <= yout_r;
    done <= done_r;
end

endmodule