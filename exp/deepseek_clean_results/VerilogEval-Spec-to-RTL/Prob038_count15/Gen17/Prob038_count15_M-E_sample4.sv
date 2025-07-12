module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] binary_count;

// Binary counter with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        binary_count <= 4'b0000;
    end else begin
        binary_count <= binary_count + 1'b1;
    end
end

// Binary to Gray code conversion
assign q = {binary_count[3], 
            binary_count[3] ^ binary_count[2],
            binary_count[2] ^ binary_count[1],
            binary_count[1] ^ binary_count[0]};

endmodule