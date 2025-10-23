module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg prev_counter;

always @(posedge clk) begin
    if (load) begin
        counter <= data;
        prev_counter <= 10'b0;
    end else if (~load && counter > 10'b0) begin
        counter <= counter - 1'b1;
        prev_counter <= counter;
    end else if (~load && counter == 10'b0) begin
        counter <= 10'b0;
        prev_counter <= 10'b0;
    end
end

assign tc = (counter == 10'b0) ? 1'b1 : 1'b0;

endmodule