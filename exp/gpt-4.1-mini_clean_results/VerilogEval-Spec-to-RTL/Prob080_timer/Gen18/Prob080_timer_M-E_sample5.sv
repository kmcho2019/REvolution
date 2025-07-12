module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg zero_flag;  // Indicates whether counter reached zero

always @(posedge clk) begin
    if (load) begin
        counter <= data;
        zero_flag <= 1'b0;
    end else if (!zero_flag) begin
        if (counter == 10'd1) begin
            counter <= 10'd0;
            zero_flag <= 1'b1;
        end else begin
            counter <= counter - 1'b1;
            zero_flag <= 1'b0;
        end
    end
    // else zero_flag and counter hold their values (counter = 0)
end

assign tc = zero_flag;

endmodule