module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_state;

    // Create extended version with boundary zeros
    wire [513:0] extended_q = {1'b0, q, 1'b0};

    // Compute next state in parallel
    assign next_state = extended_q[512:1] ^ extended_q[514:3];

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule