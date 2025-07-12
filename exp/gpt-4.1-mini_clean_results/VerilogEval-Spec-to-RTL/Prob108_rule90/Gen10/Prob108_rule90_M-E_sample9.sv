module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] next_state;

    // Compute next_state: XOR of left and right neighbors with zero boundary padding
    assign next_state = (q << 1) ^ (q >> 1);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule