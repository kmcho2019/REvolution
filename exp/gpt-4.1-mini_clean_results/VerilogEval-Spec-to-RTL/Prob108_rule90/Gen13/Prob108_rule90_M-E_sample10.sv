module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    reg [511:0] q_reg;

    // Extended vector with zero-padded boundaries for neighbor calculation
    wire [513:0] extended;

    assign extended = {1'b0, q_reg, 1'b0};

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_gen
            // next state = XOR of left and right neighbors (ignoring center)
            assign next_q[i] = extended[i] ^ extended[i+2];
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q_reg <= data;
        else
            q_reg <= next_q;
    end

    always @(*) begin
        q = q_reg;
    end

endmodule