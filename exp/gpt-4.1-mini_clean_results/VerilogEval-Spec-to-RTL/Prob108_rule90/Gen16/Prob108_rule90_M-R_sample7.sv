module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    reg [511:0] state;

    // Compute next_state combinationally with zero boundary
    wire [511:0] left_shifted  = {state[510:0], 1'b0};  // left neighbor; q[-1]=0
    wire [511:0] right_shifted = {1'b0, state[511:1]};  // right neighbor; q[512]=0
    wire [511:0] next_state = left_shifted ^ right_shifted;

    always @(posedge clk) begin
        if (load)
            state <= data;
        else
            state <= next_state;
    end

    assign q = state;
endmodule