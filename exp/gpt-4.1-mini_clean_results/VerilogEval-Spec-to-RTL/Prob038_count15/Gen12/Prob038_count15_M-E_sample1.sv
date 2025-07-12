module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);
    reg [15:0] one_hot;

    // Function to decode one_hot to binary count
    function [3:0] one_hot_to_bin;
        input [15:0] vec;
        integer i;
        begin
            one_hot_to_bin = 4'd0;
            for (i=0; i<16; i=i+1) begin
                if (vec[i]) one_hot_to_bin = i[3:0];
            end
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            one_hot <= 16'b0000_0000_0000_0001; // Start at count 0
        end else begin
            // Rotate left by 1 to move one-hot bit
            one_hot <= {one_hot[14:0], one_hot[15]};
        end
        // Decode one-hot to binary output
        q <= one_hot_to_bin(one_hot);
    end
endmodule