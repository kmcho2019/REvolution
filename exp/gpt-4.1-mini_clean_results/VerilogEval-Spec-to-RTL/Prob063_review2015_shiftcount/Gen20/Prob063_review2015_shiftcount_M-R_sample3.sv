module TopModule(
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    // Compute shifted value: shift left, MSB first, data enters LSB
    wire [3:0] shifted_value = {q[2:0], data};

    // Compute decremented value using built-in subtraction
    wire [3:0] decremented_value = q - 4'd1;

    always @(posedge clk) begin
        if (shift_ena) begin
            q <= shifted_value;
        end else if (count_ena) begin
            q <= decremented_value;
        end else begin
            q <= q; // hold current state
        end
    end

endmodule