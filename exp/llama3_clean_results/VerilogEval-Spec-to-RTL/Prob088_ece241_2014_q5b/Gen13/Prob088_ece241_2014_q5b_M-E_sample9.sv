module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] counter; // Counter to keep track of consecutive 'x' inputs

always @(posedge clk or posedge areset) begin
    if(areset) counter <= 2'b00; 
    else if (x) counter <= counter + 1'b1; 
    else counter <= 2'b00;
end

always @(*) begin
    z = (counter[0] == 1'b1) ? 1'b1 : 1'b0;
end

endmodule