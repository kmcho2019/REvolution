module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pad q with zero bits at boundaries to simplify neighbor extraction
    wire [513:0] padded_state = {1'b0, q, 1'b0};

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_gen
            wire [2:0] neighborhood = padded_state[i + 2 -: 3]; // {left, center, right}

            // Decode next state using Rule 110 LUT
            // Note: neighborhood bit order is [left, center, right]
            // According to Rule 110 truth table:
            // 111->0, 110->1, 101->1, 100->0, 011->1, 010->1, 001->1, 000->0
            // Represented by 8-bit vector indexed by neighborhood
            // LUT bit positions: neighborhood as index in binary (left=bit2,...)
            // For example, index 7 = 3'b111 -> 0
            // We create a function inline with a case statement
            reg next_bit;
            always @(*) begin
                case (neighborhood)
                    3'b111: next_bit = 1'b0;
                    3'b110: next_bit = 1'b1;
                    3'b101: next_bit = 1'b1;
                    3'b100: next_bit = 1'b0;
                    3'b011: next_bit = 1'b1;
                    3'b010: next_bit = 1'b1;
                    3'b001: next_bit = 1'b1;
                    3'b000: next_bit = 1'b0;
                    default: next_bit = 1'b0; // safety default
                endcase
            end

            assign next_q[i] = next_bit;
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule