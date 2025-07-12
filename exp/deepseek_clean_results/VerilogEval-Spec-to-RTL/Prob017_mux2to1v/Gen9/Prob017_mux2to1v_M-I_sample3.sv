module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    input         clk,
    input         enable,
    output reg [99:0] out
);

    // Internal mux signals divided into 5 chunks of 20 bits each
    wire [19:0] mux_chunk0 = sel ? b[19:0] : a[19:0];
    wire [19:0] mux_chunk1 = sel ? b[39:20] : a[39:20];
    wire [19:0] mux_chunk2 = sel ? b[59:40] : a[59:40];
    wire [19:0] mux_chunk3 = sel ? b[79:60] : a[79:60];
    wire [19:0] mux_chunk4 = sel ? b[99:80] : a[99:80];

    // Registered output with enable
    always @(posedge clk) begin
        if (enable) begin
            out[19:0]   <= mux_chunk0;
            out[39:20]  <= mux_chunk1;
            out[59:40]  <= mux_chunk2;
            out[79:60]  <= mux_chunk3;
            out[99:80]  <= mux_chunk4;
        end
    end

endmodule