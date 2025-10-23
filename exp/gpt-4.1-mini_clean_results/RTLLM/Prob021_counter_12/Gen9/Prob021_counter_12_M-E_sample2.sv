module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

// Internal binary count register for tracking the counter state
reg [3:0] binary_count;

// Function to convert binary to gray code (not used for output, only internal transition logic)
function [3:0] bin_to_gray;
    input [3:0] bin_in;
    begin
        bin_to_gray = bin_in ^ (bin_in >> 1);
    end
endfunction

// Function to convert gray code to binary (not used here, kept for clarity)
// In this design, we don't convert gray back, but the output is binary_count

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        binary_count <= 4'd0;
        out <= 4'd0;
    end else begin
        if (valid_count) begin
            // Calculate next count in binary
            if (binary_count == 4'd11)
                binary_count <= 4'd0;
            else
                binary_count <= binary_count + 1'b1;
        end
        // Update output with current binary count
        out <= binary_count;
    end
end

endmodule