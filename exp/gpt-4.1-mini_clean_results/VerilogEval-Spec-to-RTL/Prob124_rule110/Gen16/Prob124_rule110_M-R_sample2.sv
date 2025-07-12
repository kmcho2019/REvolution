module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Extended state with zero boundary padding
    wire [513:0] ext_q;
    assign ext_q = {1'b0, q, 1'b0};

    reg [511:0] next_q;

    integer i;
    always @* begin
        for (i = 0; i < 512; i = i + 1) begin
            // neighbors: ext_q[i+2] = left, ext_q[i+1] = center, ext_q[i] = right
            next_q[i] = (~ext_q[i+2] & ext_q[i+1]) | (ext_q[i+1] ^ ext_q[i]);
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule