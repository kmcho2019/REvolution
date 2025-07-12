module TopModule (
    input              clk,
    input              load,
    input      [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    integer i;
    localparam [7:0] rule = 8'b01101110;  // Rule 110 lookup table

    // Combinational logic: compute next state based on current q
    always @* begin
        for (i = 0; i < 512; i = i + 1) begin
            // Extract neighbors with boundary conditions
            // Left = q[i+1] (or 0 if i == 511)
            // Center = q[i]
            // Right = q[i-1] (or 0 if i == 0)
            reg left, center, right;
            reg [2:0] idx;

            left   = (i < 511) ? q[i+1] : 1'b0;
            center = q[i];
            right  = (i > 0) ? q[i-1] : 1'b0;

            idx = {left, center, right};
            next_q[i] = rule[idx];
        end
    end

    // Sequential logic: update state q on clock edge or load data
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule