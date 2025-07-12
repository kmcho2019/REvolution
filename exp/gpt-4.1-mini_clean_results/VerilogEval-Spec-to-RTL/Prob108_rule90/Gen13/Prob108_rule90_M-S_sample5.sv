module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [513:0] extended_q;  // q padded with zeros at boundaries

    // Pad q with zero at left and right boundaries
    assign extended_q = {1'b0, q, 1'b0};

    wire [511:0] next_state;
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : calc_next_state
            assign next_state[i] = extended_q[i] ^ extended_q[i+2];
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule