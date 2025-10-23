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
            q[0] <= q[31] ^ q[TAP_22] ^ q[TAP_2] ^ q[TAP_1];
            for (int i = 1; i < 32; i++) begin
                q[i] <= q[i-1];
            end
        end
    end

endmodule