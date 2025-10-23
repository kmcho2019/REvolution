module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] count;

always @(posedge clk) begin
    if(a) begin
        count <= count; // hold the count when a is high
    end else begin
        if(count == 4) begin
            count <= 0; // reset to 0 after reaching 4
        end else begin
            count <= count + 1; // increment the count when a is low
        end
    end
end

assign q = count;

endmodule