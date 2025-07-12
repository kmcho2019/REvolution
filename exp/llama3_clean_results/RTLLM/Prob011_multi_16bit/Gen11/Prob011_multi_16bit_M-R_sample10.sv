module multi_16bit(
    input clk, 
    input rst_n, 
    input start, 
    input [15:0] ain, 
    input [15:0] bin, 
    output reg [31:0] yout, 
    output reg done
);

reg [4:0] i;
reg [31:0] yout_r;
reg [2:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // idle
        i <= 0;
        yout_r <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (start) begin
                    state <= 1; // multiply
                    i <= 0;
                    yout_r <= 0;
                    done <= 0;
                end
            end
            1: begin // multiply
                if (i < 16) begin
                    if (ain[i]) begin
                        yout_r <= yout_r + (bin << i);
                    end
                    i <= i + 1;
                end else begin
                    state <= 2; // done
                    done <= 1;
                end
            end
            2: begin // done
                if (~start) begin
                    state <= 0; // idle
                    i <= 0;
                    yout_r <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

assign yout = yout_r;

endmodule