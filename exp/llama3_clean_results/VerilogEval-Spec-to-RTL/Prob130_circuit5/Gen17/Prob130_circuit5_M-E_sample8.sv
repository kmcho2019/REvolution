module TopModule(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

    wire enable_a, enable_b, enable_d, enable_e;
    wire [3:0] default_value;

    // Create a distributed decoder to generate enable signals
    assign enable_b = (c == 4'd0);
    assign enable_e = (c == 4'd1);
    assign enable_a = (c == 4'd2);
    assign enable_d = (c == 4'd3);

    // Create a default value (4'd15) for 'c' values beyond 3
    assign default_value = 4'd15;

    // Use the enable signals to selectively pass input signals to the output 'q'
    always @(*) begin
        if (enable_b) begin
            q = b;
        end else if (enable_e) begin
            q = e;
        end else if (enable_a) begin
            q = a;
        end else if (enable_d) begin
            q = d;
        end else begin
            q = default_value;
        end
    end

endmodule