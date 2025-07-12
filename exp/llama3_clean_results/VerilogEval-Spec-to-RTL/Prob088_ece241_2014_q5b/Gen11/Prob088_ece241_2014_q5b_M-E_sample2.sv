module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] counter; // 1-bit counter

always @(*) begin
    z = counter[0]; // output z is the value of the counter
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        counter <= 1'b0; // reset counter to 0
    end else begin
        if(x) begin
            counter <= counter + 1'b1; // increment counter when x is 1
        end else begin
            counter <= 1'b0; // reset counter to 0 when x is 0
        end
    end
end

endmodule