module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

reg [9:0] count;

always @(posedge clk) begin
    if (load) begin
        count <= data;
        tc <= 1'b0; // Reset tc when loading new value
    end else if (count > 0) begin
        count <= count - 1;
        tc <= 1'b0; // tc is low until count reaches 0
    end else begin
        tc <= 1'b1; // tc is high when count reaches 0
    end
end

endmodule