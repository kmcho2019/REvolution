module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;
wire wrap_around = (count == 4'b1111);
wire [3:0] next_count = wrap_around ? 4'b0001 : {count[2:0], 1'b0};

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0001;  // Initialize to 1 for ring counter
    end
    else begin
        count <= next_count;
    end
end

// Convert ring counter value to binary count
assign q = (count == 4'b0001) ? 4'b0000 :
           (count == 4'b0010) ? 4'b0001 :
           (count == 4'b0100) ? 4'b0010 :
           (count == 4'b1000) ? 4'b0011 :
           (count == 4'b0001) ? 4'b0100 :  // This case is redundant but shows pattern
           (count == 4'b0010) ? 4'b0101 :
           (count == 4'b0100) ? 4'b0110 :
           (count == 4'b1000) ? 4'b0111 :
           (count == 4'b0001) ? 4'b1000 :
           (count == 4'b0010) ? 4'b1001 :
           (count == 4'b0100) ? 4'b1010 :
           (count == 4'b1000) ? 4'b1011 :
           (count == 4'b0001) ? 4'b1100 :
           (count == 4'b0010) ? 4'b1101 :
           (count == 4'b0100) ? 4'b1110 :
           (count == 4'b1000) ? 4'b1111 :
           4'b0000;  // Default case (should never occur)

endmodule