module JC_counter (
    input  wire       clk,    // Clock input, positive edge triggered
    input  wire       rst_n,  // Asynchronous active-low reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

    reg next_msb;  // Registered inverse of Q[0] to break combinational path

    // Register the inverse of Q[0] at each clock to reduce combinational fanout
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            next_msb <= 1'b0;
        else
            next_msb <= ~Q[0];
    end

    // Shift right by 1 and insert next_msb at MSB on each clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            Q <= 64'b0;
        else
            Q <= {next_msb, Q[63:1]};
    end

endmodule