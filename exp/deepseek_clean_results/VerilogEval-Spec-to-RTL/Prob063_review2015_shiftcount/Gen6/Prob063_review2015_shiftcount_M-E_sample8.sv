module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena | count_ena) begin
        if (shift_ena) begin
            // Rotate right with new data at MSB (shift operation)
            q <= {data, q[3:1]};
        end else begin // count_ena is 1
            // Rotate left (decrement operation)
            q <= {q[0], q[3:1]};
        end
    end
    // else q remains unchanged
end

endmodule