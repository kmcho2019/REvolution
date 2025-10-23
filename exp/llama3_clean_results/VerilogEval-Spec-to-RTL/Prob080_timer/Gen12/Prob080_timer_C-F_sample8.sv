module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg enable;

// Control logic
always @(posedge clk) begin
    if (load) begin
        enable <= 1'b0;
    end else begin
        enable <= 1'b1;
    end
end

// Down-counter
always @(posedge clk) begin
    if (load) begin
        counter <= data;
    end else if (enable && counter!= 10'd0) begin
        counter <= counter - 1;
    end
end

// Terminal count logic
assign tc = (counter == 10'd0);

endmodule