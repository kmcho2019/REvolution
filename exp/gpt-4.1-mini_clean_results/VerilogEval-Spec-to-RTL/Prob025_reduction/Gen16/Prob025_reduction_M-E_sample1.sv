module TopModule (
    input  [7:0] in,
    output       parity
);
    reg parity_acc;
    integer i;

    always @(*) begin
        parity_acc = 0;
        for (i = 0; i < 8; i = i + 1) begin
            parity_acc = parity_acc ^ in[i];
        end
    end

    assign parity = parity_acc;
endmodule