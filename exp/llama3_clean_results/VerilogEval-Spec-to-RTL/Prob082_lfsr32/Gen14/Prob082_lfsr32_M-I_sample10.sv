module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

    // Define the tap positions
    localparam TAP_32 = 31;
    localparam TAP_22 = 21;
    localparam TAP_2  = 1;
    localparam TAP_1  = 0;

    // Handle the LFSR operation and reset
    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            reg [31:0] next_q;
            next_q[31] <= q[30];
            next_q[30:22] <= q[29:21];
            next_q[21] <= q[20] ^ q[0];
            next_q[20:2] <= q[19:1];
            next_q[1] <= q[0] ^ q[0];
            next_q[0] <= q[31] ^ q[21] ^ q[1] ^ q[0];
            q <= next_q;
        end
    end

endmodule