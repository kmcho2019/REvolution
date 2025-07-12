module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg load_reg;

always @(posedge clk) begin
    if (load) begin
        counter <= data;
        load_reg <= load;
    end else if (!load && counter > 0) begin
        counter <= counter - 1;
    end
end

assign tc = (counter == 0);

endmodule