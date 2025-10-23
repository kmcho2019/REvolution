module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Declare all variables outside always block
    reg [511:0] next_q;
    reg left, center, right;
    reg [2:0] idx;
    integer i;
    localparam [7:0] rule = 8'b01101110;  // Rule 110 lookup table

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (i = 0; i < 512; i = i + 1) begin
                // Extract neighbors with boundary conditions
                left   = (i < 511) ? q[i+1] : 1'b0;
                center = q[i];
                right  = (i > 0) ? q[i-1] : 1'b0;
                idx = {left, center, right};
                next_q[i] = rule[idx];
            end
            q <= next_q;
        end
    end

endmodule