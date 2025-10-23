module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] binary_count;
wire [3:0] gray_count;

// Binary to Gray code conversion
assign gray_count = {binary_count[3], 
                    binary_count[3] ^ binary_count[2],
                    binary_count[2] ^ binary_count[1],
                    binary_count[1] ^ binary_count[0]};

always @(posedge clk) begin
    if (reset) begin
        binary_count <= 4'b0000;
    end
    else begin
        if (binary_count == 4'b1001) begin  // 9 in binary
            binary_count <= 4'b0000;
        end
        else begin
            binary_count <= binary_count + 1'b1;
        end
    end
end

assign q = gray_count;

endmodule