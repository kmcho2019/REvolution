module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_state;

    // Compute next state according to Rule 90 with zero boundary conditions
    assign next_state = {
        // For bit 511, left neighbor = q[510], right neighbor = 0
        q[510] ^ 1'b0,
        // For bits 510 down to 1
        (q[509:0] ^ q[511:1]),
        // For bit 0, left neighbor = 0, right neighbor = q[1]
        1'b0 ^ q[1]
    };

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule