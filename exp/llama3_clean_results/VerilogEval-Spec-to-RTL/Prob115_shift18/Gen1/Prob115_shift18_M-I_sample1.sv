module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

always @(posedge clk) begin
    if(load) begin
        q <= data;
    end else if(ena) begin
        case(amount)
            2'b00: q <= {q[62:0], 1'b0};  // shift left by 1 bit
            2'b01: q <= {q[55:0], 8'b0};  // shift left by 8 bits
            2'b10: begin
                if(q[63]) begin
                    q <= {q[63], q[63:1]};  // arithmetic right shift by 1 bit, corrected syntax
                end else begin
                    q <= {1'b0, q[63:1]};  // logical right shift by 1 bit
                end
            end
            2'b11: begin
                if(q[63]) begin
                    q <= {8{q[63]}, q[63:8]};  // arithmetic right shift by 8 bits, corrected syntax
                end else begin
                    q <= {8'b0, q[63:8]};  // logical right shift by 8 bits
                end
            end
            default: q <= q;
        endcase
    end else begin
        q <= q;
    end
end

endmodule