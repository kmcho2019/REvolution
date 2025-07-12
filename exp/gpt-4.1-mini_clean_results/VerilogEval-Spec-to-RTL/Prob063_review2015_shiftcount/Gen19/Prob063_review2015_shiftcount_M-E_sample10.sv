module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    // On each positive edge, update q according to control signals
    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift left by one, input new data at MSB
            q <= {q[2:0], data};
        end else if (count_ena) begin
            // Decrement q modulo 16
            q <= q - 4'd1;
        end else begin
            // Hold value
            q <= q;
        end
    end

    // Optional synchronous initialization (for simulation)
    initial begin
        q = 4'b0000;
    end

endmodule