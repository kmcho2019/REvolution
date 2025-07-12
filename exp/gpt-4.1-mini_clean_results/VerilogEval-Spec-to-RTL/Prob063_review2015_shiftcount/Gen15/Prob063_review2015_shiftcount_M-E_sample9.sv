module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    wire [3:0] shift_result;
    wire [3:0] count_result;
    wire ena;
    wire [3:0] next_q;

    // Shift left by one, shift data into LSB (MSB first means data shifts into MSB first, so shift left)
    assign shift_result = {q[2:0], data};

    // Decrement by 1
    assign count_result = q - 4'd1;

    // Enable is set if either shift or count is active
    assign ena = shift_ena | count_ena;

    // Priority mux: shift_ena has priority if both are active (don't care case)
    assign next_q = shift_ena ? shift_result :
                    count_ena ? count_result :
                    q;

    always @(posedge clk) begin
        if (ena) begin
            q <= next_q;
        end
    end

endmodule