module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state directly in always block
            for (integer i = 0; i < 512; i = i + 1) begin
                // Handle boundaries and compute XOR in one step
                q[i] <= (i == 0 ? 1'b0 : q[i-1]) ^ (i == 511 ? 1'b0 : q[i+1]);
            end
        end
    end

endmodule