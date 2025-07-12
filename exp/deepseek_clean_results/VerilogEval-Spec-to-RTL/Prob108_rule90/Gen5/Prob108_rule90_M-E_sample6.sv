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
            // Create extended version with boundary zeros
            reg [513:0] extended_q = {1'b0, q, 1'b0};
            
            // Compute next state for each cell
            for (integer i = 0; i < 512; i = i + 1) begin
                q[i] <= extended_q[i] ^ extended_q[i+2];
            end
        end
    end

endmodule