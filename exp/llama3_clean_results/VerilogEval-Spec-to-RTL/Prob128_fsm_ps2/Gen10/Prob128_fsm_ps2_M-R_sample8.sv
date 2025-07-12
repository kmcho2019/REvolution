module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] counter;

always_ff @(posedge clk) begin
    if (reset) begin
        counter <= 2'b00;
    end else if (in[3] && counter == 2'b00) begin
        counter <= 2'b01;
    end else if (counter!= 2'b00) begin
        counter <= counter + 1'b1;
    end
end

assign done = (counter == 2'b11);

endmodule