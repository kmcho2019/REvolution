module TopModule (
    input        clk,
    input        load,
    input        ena,
    input  [1:0] amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];
    reg [63:0] shift_val;

    always @(*) begin
        case (amount)
            2'b00: begin // shift left by 1
                shift_val = q << 1;
            end
            2'b01: begin // shift left by 8
                shift_val = q << 8;
            end
            2'b10: begin // arithmetic shift right by 1
                shift_val = {msb, q[63:1]};
            end
            2'b11: begin // arithmetic shift right by 8
                shift_val = {{8{msb}}, q[63:8]};
            end
            default: shift_val = q;
        endcase
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift_val;
        end
        // else hold q
    end

endmodule