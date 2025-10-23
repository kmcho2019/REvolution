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
            // For left neighbors: shift q left by 1, zero padding on LSB
            // For right neighbors: shift q right by 1, zero padding on MSB
            q <= ({q[510:0], 1'b0}) ^ ({1'b0, q[511:1]});
        end
    end

endmodule