module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // State encoding
    localparam [2:0]
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100;

    reg [2:0] state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else begin
            if (state == S0)
                state <= x ? S1 : S0;
            else if (state == S1)
                state <= x ? S4 : S1;
            else if (state == S2)
                state <= x ? S1 : S2;
            else if (state == S3)
                state <= x ? S2 : S1;
            else if (state == S4)
                state <= x ? S4 : S3;
            else
                state <= S0;
        end
    end

    // Output combinational logic
    assign z = (state == S3) || (state == S4);

endmodule