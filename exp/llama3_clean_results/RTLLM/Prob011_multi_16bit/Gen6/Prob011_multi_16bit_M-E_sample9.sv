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
reg done_r;
reg start_pipe;

reg [31:0] pipe1;
reg [31:0] pipe2;
reg [31:0] pipe3;

assign yout = yout_r;
assign done = done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        i <= 0;
        done_r <= 0;
        pipe1 <= 0;
        pipe2 <= 0;
        pipe3 <= 0;
        start_pipe <= 0;
    end else begin
        if (start) begin
            areg <= ain;
            breg <= bin;
            start_pipe <= 1;
        end

        // Stage 1: Load multiplicand and multiplier
        if (start_pipe && i == 0) begin
            pipe1 <= {16'd0, areg};
            pipe2 <= breg;
            i <= i + 1;
        end

        // Stage 2: Bit-wise multiplication and accumulation
        if (i > 0 && i < 17) begin
            if (pipe2[i-1] == 1) begin
                pipe3 <= pipe1 + (pipe2 << (i-1));
            end else begin
                pipe3 <= pipe1;
            end
            i <= i + 1;
        end

        // Stage 3: Shifting of partial products
        if (i == 16) begin
            yout_r <= pipe3;
            done_r <= 1;
        end

        // Stage 4: Output final product
        if (i == 17) begin
            done_r <= 0;
            i <= 0;
            start_pipe <= 0;
        end
    end
end

endmodule