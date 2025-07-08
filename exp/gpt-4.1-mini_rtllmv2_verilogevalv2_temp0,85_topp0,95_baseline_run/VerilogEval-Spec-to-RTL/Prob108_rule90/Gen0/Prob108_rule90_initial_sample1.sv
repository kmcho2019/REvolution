module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] q_next;
    wire [513:0] padded; // zero pad q at left and right

    assign padded = {1'b0, q, 1'b0}; // q[-1]=0, q[512]=0

    genvar i;
    generate
        for (i=0; i<512; i=i+1) begin : rule90_logic
            assign q_next[i] = padded[i] ^ padded[i+2];
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= q_next;
    end

endmodule