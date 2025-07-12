module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] input_num;
reg [31:0] output;
reg [4:0] bit_count;
reg running;

initial begin
    input_num = 0;
    output = 0;
    bit_count = 0;
    running = 0;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        input_num <= 0;
        output <= 0;
        bit_count <= 0;
        running <= 0;
    end else begin
        if (!running) begin
            running <= 1;
            bit_count <= 0;
            input_num <= 0;
        end else begin
            input_num <= {input_num[30:0], x};
            bit_count <= bit_count + 1;
            if (bit_count == 31) begin
                output <= ~input_num + 1;
                running <= 0;
            end
        end
    end
end

assign z = output[0];

endmodule