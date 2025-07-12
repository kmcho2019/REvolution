module TopModule (
    input          clk,
    input          load,
    input          ena,
    input  [1:0]   amount,
    input  [63:0]  data,
    output reg [63:0] q
);

    reg [63:0] next_q;
    wire sign_bit = q[63];

    always @(*) begin
        if (load) begin
            next_q = data;
        end else if (ena) begin
            case (amount)
                2'b00: next_q = q << 1;
                2'b01: next_q = q << 8;
                2'b10: next_q = { {1{sign_bit}}, q[63:1] };
                2'b11: next_q = { {8{sign_bit}}, q[63:8] };
                default: next_q = q; // Safe fallback (not strictly needed)
            endcase
        end else begin
            next_q = q;
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule