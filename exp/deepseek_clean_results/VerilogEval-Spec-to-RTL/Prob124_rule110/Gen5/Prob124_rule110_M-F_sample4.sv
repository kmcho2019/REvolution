module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;
    wire [511:0] left = {q[510:0], 1'b0};  // q[i+1] with 0 at MSB
    wire [511:0] right = {1'b0, q[511:1]}; // q[i-1] with 0 at LSB

    // Implement Rule 110 for each cell with exact truth table matching
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin: rule110
            assign next_q[i] = (left[i] &  q[i] &  right[i]) ? 1'b0 :  // 111 → 0
                              (left[i] &  q[i] & ~right[i]) ? 1'b1 :  // 110 → 1
                              (left[i] & ~q[i] &  right[i]) ? 1'b1 :  // 101 → 1
                              (left[i] & ~q[i] & ~right[i]) ? 1'b0 :  // 100 → 0
                              (~left[i] &  q[i] &  right[i]) ? 1'b1 : // 011 → 1
                              (~left[i] &  q[i] & ~right[i]) ? 1'b1 : // 010 → 1
                              (~left[i] & ~q[i] &  right[i]) ? 1'b1 : // 001 → 1
                              1'b0;                                   // 000 → 0
        end
    endgenerate

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule