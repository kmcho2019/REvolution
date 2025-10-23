module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (count_ena) begin
            q <= q - 4'd1;         // decrement current value
        end else if (shift_ena) begin
            q <= {data, q[3:1]};  // shift right, load data into MSB (MSB-first)
        end
        // else hold current value
    end

endmodule