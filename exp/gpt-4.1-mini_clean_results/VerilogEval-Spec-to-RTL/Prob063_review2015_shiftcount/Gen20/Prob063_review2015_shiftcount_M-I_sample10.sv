module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    // Internal reset synchronizer: async reset asserted at startup, de-asserted after 2 clk cycles
    reg [1:0] rst_sync = 2'b00;
    wire resetn;

    always @(posedge clk) begin
        rst_sync <= {rst_sync[0], 1'b1}; // After two cycles, resetn will be high
    end

    assign resetn = rst_sync[1];

    // Next state logic with mutually exclusive enable signals
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            q <= 4'b0000;
        else if (shift_ena)
            q <= {q[2:0], data};       // Shift left, MSB first, new LSB data
        else if (count_ena)
            q <= q - 4'd1;             // Decrement by 1, modulo 16 (wraparound naturally)
        else
            q <= q;                   // Hold state
    end

endmodule