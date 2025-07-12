module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    integer i;
    reg [511:0] next_state;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (i = 0; i < 512; i = i + 1) begin
                // Define neighbors with zero boundary
                wire left   = (i == 511) ? 1'b0 : q[i+1];
                wire center = q[i];
                wire right  = (i == 0)   ? 1'b0 : q[i-1];
                next_state[i] = (~left & center) | (center ^ right);
            end
            q <= next_state;
        end
    end

endmodule