module TopModule (
    input          clk,
    input          shift_ena,
    input          count_ena,
    input          data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena)
            q <= {q[2:0], data};  // Shift left, MSB first, input new LSB data
        else if (count_ena)
            q <= q - 4'd1;        // Decrement
        // else q holds its value implicitly
    end

endmodule