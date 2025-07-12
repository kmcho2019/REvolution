module TopModule(
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    reg [3:0] shift_val;
    reg [3:0] count_val;
    reg [3:0] next_val;

    // Calculate shifted value: shift right by 1, input data into MSB
    always @(*) begin
        shift_val = {data, q[3:1]};
    end

    // Calculate decremented value (down counter)
    always @(*) begin
        count_val = q - 4'd1;
    end

    // Choose next value based on enables; priority doesn't matter when both are high
    always @(*) begin
        if (shift_ena)
            next_val = shift_val;
        else if (count_ena)
            next_val = count_val;
        else
            next_val = q;
    end

    // Update register at positive clock edge
    always @(posedge clk) begin
        q <= next_val;
    end

endmodule