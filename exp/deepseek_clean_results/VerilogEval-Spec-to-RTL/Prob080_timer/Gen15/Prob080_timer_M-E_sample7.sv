module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] shift_counter;

    always @(posedge clk) begin
        if (load)
            shift_counter <= ~data;  // Invert data since we're shifting a '1'
        else if (~tc)
            shift_counter <= {1'b0, shift_counter[9:1]};  // Right shift with 0 fill
    end

    assign tc = shift_counter[0];  // Terminal count when '1' reaches LSB

endmodule