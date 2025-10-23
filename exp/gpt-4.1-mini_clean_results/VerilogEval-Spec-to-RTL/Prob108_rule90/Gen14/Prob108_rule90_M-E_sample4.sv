module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Internal padded register: q_pad = {0, q, 0}
    wire [513:0] q_pad;
    assign q_pad = {1'b0, q, 1'b0};

    wire [511:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule90_logic
            assign next_state[i] = q_pad[i] ^ q_pad[i+2]; // XOR of left and right neighbors
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule