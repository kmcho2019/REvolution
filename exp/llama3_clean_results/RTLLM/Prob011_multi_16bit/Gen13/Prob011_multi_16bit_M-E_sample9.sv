module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [15:0] areg;
reg [15:0] breg;
reg [31:0] accum;
reg [4:0] count;
reg valid;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        areg <= 0;
        breg <= 0;
        accum <= 0;
        count <= 0;
        valid <= 0;
        done <= 0;
    end else begin
        if (start) begin
            areg <= ain;
            breg <= bin;
            accum <= 0;
            count <= 0;
            valid <= 1;
        end else if (valid) begin
            if (areg[0]) begin
                accum <= accum + breg;
            end
            areg <= areg >> 1;
            breg <= breg << 1;
            count <= count + 1;
            if (count == 16) begin
                valid <= 0;
                done <= 1;
            end
        end
    end
end

always @(posedge clk) begin
    if (done) begin
        yout <= accum;
    end
end

endmodule