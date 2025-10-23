module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    integer i;

    // Combinational logic to compute next state according to Rule 90
    always @(*) begin
        // Boundary cell 0: neighbors are q[-1]=0 and q[1]
        next_q[0] = 0 ^ q[1];

        // Internal cells 1 to 510: next_q[i] = q[i-1] ^ q[i+1]
        for (i = 1; i < 511; i = i + 1) begin
            next_q[i] = q[i-1] ^ q[i+1];
        end

        // Boundary cell 511: neighbors q[510] and q[512]=0
        next_q[511] = q[510] ^ 0;
    end

    // Sequential logic to update q at clock edge or load new data
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule