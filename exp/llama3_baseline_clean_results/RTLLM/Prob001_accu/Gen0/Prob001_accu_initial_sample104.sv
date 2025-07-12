module accu (
    input               clk,
    input               rst_n,
    input      [7:0]     data_in,
    input               valid_in,
    output              valid_out,
    output     [9:0]     data_out
);

reg [1:0] counter;
reg [9:0] accumulator;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 2'd0;
        accumulator <= 10'd0;
        valid_out <= 1'b0;
    end else if (valid_in) begin
        if (counter < 2'd4) begin
            accumulator <= accumulator + {{2{data_in[7]}}, data_in};
            counter <= counter + 1'd1;
            valid_out <= 1'b0;
        end else begin
            data_out <= accumulator;
            valid_out <= 1'b1;
            accumulator <= 10'd0;
            counter <= 2'd0;
        end
    end else if (counter == 2'd4) begin
        valid_out <= 1'b0;
    end
end

always @(posedge clk) begin
    if (valid_out) begin
        data_out <= accumulator;
    end
end

endmodule