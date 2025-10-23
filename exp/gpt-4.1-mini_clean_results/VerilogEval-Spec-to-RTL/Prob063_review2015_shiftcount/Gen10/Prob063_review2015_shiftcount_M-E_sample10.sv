module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        case (1'b1)
            shift_ena: q <= {q[2:0], data};
            count_ena: q <= q - 1;
            default:   q <= q;
        endcase
    end

endmodule