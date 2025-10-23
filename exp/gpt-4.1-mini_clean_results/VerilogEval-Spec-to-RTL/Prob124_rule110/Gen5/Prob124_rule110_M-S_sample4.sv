module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [513:0] extended_q;  // q extended with zeros at both ends
    reg [511:0] next_state;

    integer i;

    always @* begin
        // zero-extend q with zeros at boundaries
        extended_q = {1'b0, q, 1'b0};

        for (i = 0; i < 512; i = i + 1) begin
            // neighbors
            // left = extended_q[i+2], center = extended_q[i+1], right = extended_q[i]
            next_state[i] = (~extended_q[i+2] & extended_q[i+1]) | (extended_q[i+1] ^ extended_q[i]);
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule