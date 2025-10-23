module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg [4:0] i;
reg done_r;
reg [1:0] state;

// Next state logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        i <= 0;
        done_r <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
    end else begin
        case (state)
            0: begin // Idle state
                if (start) begin
                    state <= 1;
                    areg <= ain;
                    breg <= bin;
                    i <= 1;
                    done_r <= 0;
                    yout_r <= 0;
                end else begin
                    state <= 0;
                    i <= 0;
                    done_r <= 0;
                    areg <= 0;
                    breg <= 0;
                    yout_r <= 0;
                end
            end
            1: begin // Multiply state
                if (i < 17) begin
                    state <= 1;
                    i <= i + 1;
                    if (areg[i-1]) begin
                        yout_r <= yout_r + (breg << (i-1));
                    end
                end else if (i == 16) begin
                    state <= 0;
                    done_r <= 1;
                end else if (i == 17) begin
                    state <= 0;
                    done_r <= 0;
                end
            end
        endcase
    end
end

// Output logic
assign yout = yout_r;
assign done = done_r;

endmodule