module multi_16bit (
    input  clk, 
    input  rst_n, 
    input  start, 
    input  [15:0] ain, 
    input  [15:0] bin, 
    output [31:0] yout, 
    output done
);

reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg [4:0] i;
reg [1:0] state; // 0: idle, 1: multiply, 2: done
reg done_r;

assign yout = yout_r;
assign done = done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        i <= 0;
        done_r <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (start) begin
                    state <= 1;
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 0;
                    i <= 1;
                end
            end
            1: begin // multiply
                if (areg[i-1]) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
                if (i == 16) begin
                    state <= 2;
                    done_r <= 1;
                end else begin
                    i <= i + 1;
                end
            end
            2: begin // done
                if (!start) begin
                    state <= 0;
                    done_r <= 0;
                end
            end
        endcase
    end
end

endmodule