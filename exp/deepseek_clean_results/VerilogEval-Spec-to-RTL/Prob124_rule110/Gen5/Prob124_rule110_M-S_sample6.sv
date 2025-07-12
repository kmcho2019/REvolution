module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;
    wire [513:0] extended_q = {1'b0, q, 1'b0}; // Add boundary zeros

    // Simplified Rule 110 logic
    assign next_q = (~extended_q[513:2] & extended_q[512:1]) |  // Left=0 and Center=1
                   (~extended_q[513:2] & extended_q[510:0]) |  // Left=0 and Right=1
                   (extended_q[512:1] & ~extended_q[510:0]);    // Center=1 and Right=0

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule