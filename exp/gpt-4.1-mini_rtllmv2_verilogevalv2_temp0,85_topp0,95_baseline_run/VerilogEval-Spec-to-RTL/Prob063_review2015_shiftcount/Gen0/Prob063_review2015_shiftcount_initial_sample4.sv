module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift in MSB first: shift right, insert data at MSB
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            q <= q - 4'd1;
        end
        // else hold current q
    end

endmodule