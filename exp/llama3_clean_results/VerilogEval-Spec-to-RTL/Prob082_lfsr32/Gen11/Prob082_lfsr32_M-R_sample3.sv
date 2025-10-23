module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Define the tap positions
parameter TAP_1 = 31;
parameter TAP_2 = 21;
parameter TAP_3 = 1;
parameter TAP_4 = 0;

// Calculate the new MSB
wire new_msb;
assign new_msb = q[TAP_1] ^ q[TAP_2] ^ q[TAP_3] ^ q[TAP_4];

// Update the LFSR state
always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= {new_msb, q[31:1]};
    end
end

endmodule