module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [15:0] ain_pipe [0:3];
reg [15:0] bin_pipe;
reg [31:0] yout_pipe [0:3];
reg [1:0] stage;
reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage <= 0;
        done_r <= 0;
        bin_pipe <= 0;
        for (int i = 0; i < 4; i++) begin
            yout_pipe[i] <= 0;
            ain_pipe[i] <= 0;
        end
    end else if (start) begin
        if (stage == 0) begin
            ain_pipe[0] <= ain[15:12];
            bin_pipe <= bin;
            yout_pipe[0] <= 0;
            stage <= 1;
        end else if (stage == 1) begin
            ain_pipe[1] <= ain[11:8];
            yout_pipe[1] <= yout_pipe[0] + (bin_pipe * ain_pipe[0]);
            stage <= 2;
        end else if (stage == 2) begin
            ain_pipe[2] <= ain[7:4];
            yout_pipe[2] <= yout_pipe[1] + ((bin_pipe * ain_pipe[1]) << 4);
            stage <= 3;
        end else if (stage == 3) begin
            ain_pipe[3] <= ain[3:0];
            yout_pipe[3] <= yout_pipe[2] + ((bin_pipe * ain_pipe[2]) << 8);
            done_r <= 1;
            stage <= 0;
        end
    end else begin
        stage <= 0;
        done_r <= 0;
        bin_pipe <= 0;
        for (int i = 0; i < 4; i++) begin
            yout_pipe[i] <= 0;
            ain_pipe[i] <= 0;
        end
    end
end

assign yout = yout_pipe[3];
assign done = done_r;

endmodule