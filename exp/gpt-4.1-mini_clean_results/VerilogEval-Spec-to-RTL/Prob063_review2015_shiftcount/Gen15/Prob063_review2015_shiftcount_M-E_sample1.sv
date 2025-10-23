module TopModule(
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    wire [3:0] shifted_val;
    wire [3:0] decremented_val;
    wire [3:0] next_val;

    // Shift left by 1, inserting data at LSB (MSB-first shifting)
    assign shifted_val = {q[2:0], data};

    // Decrement q by 1 modulo 16
    assign decremented_val = q - 4'd1;

    // Select next value based on enables; when both are 0, hold q
    // If both shift_ena and count_ena are 1, priority doesn't matter
    assign next_val = shift_ena ? shifted_val :
                      count_ena ? decremented_val :
                      q;

    always @(posedge clk) begin
        q <= next_val;
    end

endmodule