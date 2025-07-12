module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] buffer;
reg [1:0] ptr;  // Circular buffer pointer

// Output rotation logic
assign q = {buffer, buffer} >> ptr;  // Efficient rotation using concatenation

always @(posedge clk or posedge areset) begin
    if (areset) begin
        buffer <= 4'b0;
        ptr <= 2'b0;
    end
    else if (load) begin
        buffer <= data;
        ptr <= 2'b0;  // Reset pointer on load
    end
    else if (ena) begin
        ptr <= ptr + 1;  // Simulate shift by moving pointer
        buffer[3] <= 1'b0;  // Maintain MSB=0 for right shift behavior
    end
end

endmodule