module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [513:0] extended_q = {1'b0, q, 1'b0}; // Handle boundaries with zero padding

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Process all bits in parallel with optimized Rule 110 logic
            for (integer i = 0; i < 512; i = i + 1) begin
                // Neighbors are extended_q[i+2] (left), extended_q[i+1] (center), extended_q[i] (right)
                q[i] <= extended_q[i] ? 
                       (extended_q[i+1] | ~extended_q[i+2]) : 
                       (extended_q[i+1] & extended_q[i+2]);
            end
        end
    end

endmodule