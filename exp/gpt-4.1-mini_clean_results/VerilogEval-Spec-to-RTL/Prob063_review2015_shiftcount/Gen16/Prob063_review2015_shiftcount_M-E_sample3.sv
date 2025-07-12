module TopModule(
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    wire [3:0] decremented = q - 4'd1;  // combinational subtractor

    // Synchronous reset: initialize to zero at start
    reg init_done = 0;

    always @(posedge clk) begin
        if (!init_done) begin
            q <= 4'b0000;
            init_done <= 1;
        end else if (count_ena) begin
            q <= decremented; // decrement takes priority over shift
        end else if (shift_ena) begin
            q <= {data, q[3:1]}; // shift MSB first: new data into MSB, shift right
        end else begin
            q <= q; // hold
        end
    end

endmodule