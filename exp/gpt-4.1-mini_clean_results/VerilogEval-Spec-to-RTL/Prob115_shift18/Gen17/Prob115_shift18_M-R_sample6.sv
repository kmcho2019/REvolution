module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    reg [63:0] next_q;

    always @(*) begin
        if (load) begin
            next_q = data;
        end else if (ena) begin
            case (amount)
                2'b00: begin // shift left by 1
                    next_q = q << 1;
                end
                2'b01: begin // shift left by 8
                    next_q = q << 8;
                end
                2'b10: begin // arithmetic shift right by 1
                    // replicate sign bit for highest bit
                    next_q = { {1{q[63]}}, q[63:1] };
                end
                2'b11: begin // arithmetic shift right by 8
                    next_q = { {8{q[63]}}, q[63:8] };
                end
                default: begin
                    next_q = q; // hold
                end
            endcase
        end else begin
            next_q = q; // hold
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule