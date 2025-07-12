module TopModule(
    input  [99:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    reg [3:0] and_chunk;
    reg [3:0] or_chunk;
    reg [3:0] xor_chunk;

    always @(in) begin
        out_and = 1'b1;
        out_or = 1'b0;
        out_xor = 1'b0;
        and_chunk = 4'b1111;
        or_chunk = 4'b0000;
        xor_chunk = 4'b0000;
        for (int i = 0; i <= 99; i++) begin
            case (i / 25)
                0: begin
                    and_chunk[0] = and_chunk[0] & in[i];
                    or_chunk[0] = or_chunk[0] | in[i];
                    xor_chunk[0] = xor_chunk[0] ^ in[i];
                end
                1: begin
                    and_chunk[1] = and_chunk[1] & in[i];
                    or_chunk[1] = or_chunk[1] | in[i];
                    xor_chunk[1] = xor_chunk[1] ^ in[i];
                end
                2: begin
                    and_chunk[2] = and_chunk[2] & in[i];
                    or_chunk[2] = or_chunk[2] | in[i];
                    xor_chunk[2] = xor_chunk[2] ^ in[i];
                end
                3: begin
                    and_chunk[3] = and_chunk[3] & in[i];
                    or_chunk[3] = or_chunk[3] | in[i];
                    xor_chunk[3] = xor_chunk[3] ^ in[i];
                end
            endcase
        end
        out_and = &and_chunk;
        out_or = |or_chunk;
        out_xor = ^xor_chunk;
    end

endmodule