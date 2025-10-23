module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0001;  // Initialize with first count value
    end
    else if (valid_count) begin
        if (out[3]) begin  // Check if we've reached count 11 (position)
            out <= 4'b0001; // Wrap around to 0 (represented as 0001)
        end
        else begin
            out <= {out[2:0], 1'b0};  // Left shift
            if (out == 4'b0000) out <= 4'b0001; // Safety catch
        end
    end
end

// Convert shift position to binary count
wire [3:0] binary_count;
assign binary_count = 
    (out == 4'b0001) ? 4'd0 :
    (out == 4'b0010) ? 4'd1 :
    (out == 4'b0100) ? 4'd2 :
    (out == 4'b1000) ? 4'd3 :
    (out == 4'b0001) ? 4'd4 : // After wrap-around
    (out == 4'b0010) ? 4'd5 :
    (out == 4'b0100) ? 4'd6 :
    (out == 4'b1000) ? 4'd7 :
    (out == 4'b0001) ? 4'd8 : // After wrap-around
    (out == 4'b0010) ? 4'd9 :
    (out == 4'b0100) ? 4'd10 :
    (out == 4'b1000) ? 4'd11 : 4'd0;

// Output either the shift register or binary count
// For this implementation, we'll output the binary count
assign out = binary_count;

endmodule