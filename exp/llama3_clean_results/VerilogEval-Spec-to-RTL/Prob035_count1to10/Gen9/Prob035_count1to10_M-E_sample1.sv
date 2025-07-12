module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] johnson_count; // Johnson counter register

always @(posedge clk) begin
    if (reset) begin
        johnson_count <= 4'b0001; // Reset to 1
    end else begin
        // Johnson counter implementation for decade counting
        // The sequence will be designed to minimize transitions and count from 1 to 10
        case (johnson_count)
            4'b0001: johnson_count <= 4'b0010;
            4'b0010: johnson_count <= 4'b0011;
            4'b0011: johnson_count <= 4'b0100;
            4'b0100: johnson_count <= 4'b0101;
            4'b0101: johnson_count <= 4'b0110;
            4'b0110: johnson_count <= 4'b0111;
            4'b0111: johnson_count <= 4'b1000;
            4'b1000: johnson_count <= 4'b1001;
            4'b1001: johnson_count <= 4'b0001; // Loop back to 1 after 10
            default: johnson_count <= 4'b0001; // Default to reset value
        endcase
    end
end

assign q = johnson_count;

endmodule