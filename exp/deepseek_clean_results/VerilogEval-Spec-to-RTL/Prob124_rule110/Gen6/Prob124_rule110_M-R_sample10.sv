module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation
    wire [511:0] next_q;

    // Create padded version of q for boundary conditions
    wire [513:0] padded_q = {1'b0, q, 1'b0};

    // Implement Rule 110 using optimized Boolean expression
    assign next_q = (padded_q[513:2] & ~padded_q[512:1]) |  // Left=1, Center=1, Right=0
                    (padded_q[513:2] & ~padded_q[511:0]) |  // Left=1, Center=0, Right=1
                    (~padded_q[513:2] & padded_q[512:1]) |  // Left=0, Center=1, (Right=X)
                    (~padded_q[513:2] & padded_q[511:0]);   // Left=0, Center=0, Right=1

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule