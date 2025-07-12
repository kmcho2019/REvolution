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
reg [15:0] areg;  // multiplicand register
reg [15:0] breg;  // multiplier register
reg [31:0] yout_r;  // product register
reg done_r;  // multiplication completion flag register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // reset condition
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
    end else begin
        if (start && i < 17) begin  // start multiplication operation
            if (i == 0) begin  // store multiplicand and multiplier
                areg <= ain;
                breg <= bin;
            end
            if (i > 0 && i < 17) begin  // perform shift and accumulate operation
                if (areg[i-1]) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
            end
            i <= i + 1;  // increment shift count
        end else if (!start) begin  // reset shift count
            i <= 0;
        end
        if (i == 16) begin  // set multiplication completion flag
            done_r <= 1;
        end else if (i == 17) begin  // reset multiplication completion flag
            done_r <= 0;
        end
    end
end

always @(*) begin
    yout = yout_r;  // assign product output
    done = done_r;  // assign multiplication completion flag
end

endmodule