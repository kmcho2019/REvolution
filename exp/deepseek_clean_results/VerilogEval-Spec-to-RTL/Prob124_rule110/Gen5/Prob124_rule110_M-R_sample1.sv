module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute Rule 110 next state
    function automatic rule110;
        input left, center, right;
        begin
            case ({left, center, right})
                3'b111: rule110 = 1'b0;
                3'b110: rule110 = 1'b1;
                3'b101: rule110 = 1'b1;
                3'b100: rule110 = 1'b0;
                3'b011: rule110 = 1'b1;
                3'b010: rule110 = 1'b1;
                3'b001: rule110 = 1'b1;
                3'b000: rule110 = 1'b0;
            endcase
        end
    endfunction

    // Next state logic
    wire [511:0] next_q;

    // Left boundary (bit 0)
    assign next_q[0] = rule110(1'b0, q[0], q[1]);

    // Middle bits (1 to 510)
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : middle_bits
            assign next_q[i] = rule110(q[i-1], q[i], q[i+1]);
        end
    endgenerate

    // Right boundary (bit 511)
    assign next_q[511] = rule110(q[510], q[511], 1'b0);

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule