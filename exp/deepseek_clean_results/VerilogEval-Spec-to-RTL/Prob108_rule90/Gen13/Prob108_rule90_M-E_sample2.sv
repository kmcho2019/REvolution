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
            // Compute next state using parallel XOR of shifted versions
            // Left shift (q << 1) with zero at LSB represents left neighbors
            // Right shift (q >> 1) with zero at MSB represents right neighbors
            q <= {1'b0, q[511:1]} ^ {q[510:0], 1'b0};
        end
    end

endmodule