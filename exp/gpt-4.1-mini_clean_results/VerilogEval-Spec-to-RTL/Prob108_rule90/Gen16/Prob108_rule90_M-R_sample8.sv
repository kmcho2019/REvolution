module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    // Pad boundaries with zeros: left shifted and right shifted vectors with zero at boundaries
    wire [512:0] padded_left  = {1'b0, q};
    wire [512:0] padded_right = {q, 1'b0};

    wire [511:0] next_state = padded_left[510:0] ^ padded_right[511:1];

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule