module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg [9:0] next_counter;

assign tc = (counter == 0) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if(load) begin
        counter <= data;
    end else if(counter != 0) begin
        counter <= counter - 1;
    end else begin
        counter <= 0; // Ensure counter stays at 0 once reached
    end
end

endmodule