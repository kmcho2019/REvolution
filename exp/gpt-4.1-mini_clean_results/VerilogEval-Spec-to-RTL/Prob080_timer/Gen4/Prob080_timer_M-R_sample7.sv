module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg [9:0] next_counter;

always @(*) begin
    if (load) begin
        next_counter = data;
    end else if (counter != 10'd0) begin
        next_counter = counter - 10'd1;
    end else begin
        next_counter = 10'd0;
    end
end

always @(posedge clk) begin
    counter <= next_counter;
end

assign tc = (counter == 10'd0);

endmodule