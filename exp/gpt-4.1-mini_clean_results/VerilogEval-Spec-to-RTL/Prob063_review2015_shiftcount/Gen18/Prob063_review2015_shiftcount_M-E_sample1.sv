module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

// Shift operation: shift left, inserting data at MSB (q[3])
always @(posedge clk) begin
    if (shift_ena)
        q <= {data, q[3:1]};
end

// Count operation: decrement q when count_ena is high and shift_ena is low
always @(posedge clk) begin
    if (~shift_ena && count_ena)
        q <= q - 1;
end

// Hold q value when neither shift_ena nor count_ena is active implicitly by no assignment

endmodule