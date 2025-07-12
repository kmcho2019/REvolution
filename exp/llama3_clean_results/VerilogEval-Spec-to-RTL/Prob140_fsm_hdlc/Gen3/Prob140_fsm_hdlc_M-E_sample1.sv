module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

reg [2:0] consecutive_ones;
reg [2:0] consecutive_zeros;
reg prev_in;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        consecutive_ones <= 3'b000;
        consecutive_zeros <= 3'b000;
        prev_in <= 1'b0;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        if (in == prev_in) begin
            if (in) begin
                consecutive_ones <= consecutive_ones + 1;
                consecutive_zeros <= 3'b000;
            end else begin
                consecutive_zeros <= consecutive_zeros + 1;
                consecutive_ones <= 3'b000;
            end
        end else begin
            consecutive_ones <= in ? 3'b001 : 3'b000;
            consecutive_zeros <= in ? 3'b000 : 3'b001;
        end

        if (consecutive_ones == 3'b110) begin
            flag <= 1'b1;
        end else begin
            flag <= 1'b0;
        end

        if (consecutive_ones == 3'b101 && !in) begin
            disc <= 1'b1;
        end else begin
            disc <= 1'b0;
        end

        if (consecutive_ones >= 3'b111) begin
            err <= 1'b1;
        end else begin
            err <= 1'b0;
        end

        prev_in <= in;
    end
end

endmodule