module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

// Rotation direction: 0=right (shift), 1=left (count)
wire rotate_left = count_ena;

always @(posedge clk) begin
    if (shift_ena | count_ena) begin
        if (rotate_left) begin
            // Rotate left for count (equivalent to decrement)
            q <= {q[2:0], ~q[3]}; // The inversion handles the borrow
        end else begin
            // Rotate right for shift with new data at MSB
            q <= {data, q[3:1]};
        end
    end
end

endmodule