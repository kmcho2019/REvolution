module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    // Shift left inserting new bit at LSB, shifting MSB first by different convention
    wire [3:0] shifted = {q[2:0], data};
    // Decrement the register
    wire [3:0] counted = q - 1;

    always @(posedge clk) begin
        if (shift_ena) 
            q <= shifted;
        else if (count_ena)
            q <= counted;
    end

endmodule