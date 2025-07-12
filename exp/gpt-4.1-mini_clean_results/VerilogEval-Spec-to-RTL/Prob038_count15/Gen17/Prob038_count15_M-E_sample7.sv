module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);
    reg [3:0] gray;

    // Gray code increment: next_gray = current_gray + 1 in Gray code sequence
    wire [3:0] next_gray;
    assign next_gray[3] = gray[3] ^ ~gray[2];
    assign next_gray[2] = gray[2] ^ gray[1];
    assign next_gray[1] = gray[1] ^ gray[0];
    assign next_gray[0] = ~gray[0];

    // Convert Gray code to binary
    wire [3:0] binary_from_gray;
    assign binary_from_gray[3] = gray[3];
    assign binary_from_gray[2] = gray[3] ^ gray[2];
    assign binary_from_gray[1] = binary_from_gray[2] ^ gray[1];
    assign binary_from_gray[0] = binary_from_gray[1] ^ gray[0];

    always @(posedge clk) begin
        if (reset)
            gray <= 4'b0000;
        else
            gray <= next_gray;
    end

    always @(*) begin
        q = binary_from_gray;
    end
endmodule