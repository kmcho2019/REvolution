module TopModule (
    input          clk,
    input          shift_ena,
    input          count_ena,
    input          data,
    output reg [3:0] q
);

    // Combined enable for register update to reduce toggling power
    wire ena = shift_ena | count_ena;

    reg [3:0] next_q;

    always @* begin
        if (shift_ena)
            next_q = {q[2:0], data};  // Shift left, MSB first, input new LSB data
        else if (count_ena)
            next_q = q - 4'd1;        // Arithmetic decrement, synth-friendly
        else
            next_q = q;               // Hold current value
    end

    always @(posedge clk) begin
        if (ena)
            q <= next_q;
    end

endmodule