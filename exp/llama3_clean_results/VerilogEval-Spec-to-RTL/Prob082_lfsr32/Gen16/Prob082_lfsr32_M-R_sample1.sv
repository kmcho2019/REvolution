module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q[31] <= q[30];
            q[30:22] <= q[29:21];
            q[21] <= q[20] ^ q[0];
            q[20:2] <= q[19:1];
            q[1] <= q[0] ^ q[0];  
            q[0] <= q[31] ^ q[21] ^ q[2] ^ q[1];  
        end
    end

    // Alternatively, using a more combinational approach
    // always @(posedge clk) begin
    //     if (reset) begin
    //         q <= 32'h1;
    //     end else begin
    //         reg [31:0] next_q;
    //         next_q[31:1] = q[30:0];
    //         next_q[21] = q[20] ^ q[0];
    //         next_q[1] = q[0];
    //         next_q[0] = q[31] ^ q[21] ^ q[2] ^ q[1];
    //         q <= next_q;
    //     end
    // end

endmodule