module TopModule(
    input clk,
    input rst_n,       // Active-low asynchronous reset
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    // Asynchronous reset ensures known startup value for q
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 4'b0000;
        end else if (shift_ena) begin
            // Shift right, insert data at MSB (bit 3)
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Down counter decrement with wrap-around on underflow
            q <= q - 4'd1;
        end
        // else hold q
    end

endmodule