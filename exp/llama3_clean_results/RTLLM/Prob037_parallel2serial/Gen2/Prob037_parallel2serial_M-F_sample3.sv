module parallel2serial(
    input           clk,
    input           rst_n,
    input   [3:0]   d,
    output          valid_out,
    output          dout
);

reg [3:0] data;
reg [1:0] cnt;
reg       valid;

assign valid_out = valid;
assign dout = data[3];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data <= 4'b0;
        cnt <= 2'b0;
        valid <= 1'b0;
    end else begin
        if (~valid) begin
            data <= d;
            cnt <= 2'b0;
            valid <= 1'b1;
        end else begin
            // Shift the data to the right to output the next bit
            data <= {data[2:0], 1'b0};
            cnt <= cnt + 1'b1;
            // After outputting all bits, reset valid and counter
            if (cnt == 2'b11) begin
                valid <= 1'b0;
            end
        end
    end
end

endmodule