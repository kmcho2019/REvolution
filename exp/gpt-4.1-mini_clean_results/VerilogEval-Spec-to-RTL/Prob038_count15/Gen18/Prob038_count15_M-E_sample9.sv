module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] binary_count;

    // Binary counter with synchronous reset
    always @(posedge clk) begin
        if (reset)
            binary_count <= 4'b0000;
        else
            binary_count <= binary_count + 1;
    end

    // Convert binary count to Gray code combinationally
    always @(*) begin
        q[3] = binary_count[3];
        q[2] = binary_count[3] ^ binary_count[2];
        q[1] = binary_count[2] ^ binary_count[1];
        q[0] = binary_count[1] ^ binary_count[0];
    end

endmodule