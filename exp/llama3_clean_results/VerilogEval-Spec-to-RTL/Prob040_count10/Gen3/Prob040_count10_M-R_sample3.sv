module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    case ({reset, count})
        5'b10_?: begin  // Reset is high, set count to 0 regardless of current count
            count <= 4'b0000;
        end
        5'b01_1001: begin  // Count is 9, wrap around to 0
            count <= 4'b0000;
        end
        default: begin  // Increment count for all other cases
            count <= count + 4'd1;
        end
    endcase
end

assign q = count;

endmodule