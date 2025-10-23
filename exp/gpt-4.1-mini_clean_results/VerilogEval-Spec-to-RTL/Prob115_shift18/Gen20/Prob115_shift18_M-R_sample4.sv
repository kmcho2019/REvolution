module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    // Function to perform the specified shifts with sign extension on right shifts
    function [63:0] shift_ari;
        input [63:0] in;
        input [1:0]  amt;
        reg msb;
        begin
            msb = in[63];
            case (amt)
                2'b00: shift_ari = {in[62:0], 1'b0};                // shift left by 1
                2'b01: shift_ari = {in[55:0], 8'b0};                // shift left by 8
                2'b10: shift_ari = {msb, in[63:1]};                 // arithmetic shift right by 1
                2'b11: shift_ari = {{8{msb}}, in[63:8]};            // arithmetic shift right by 8
                default: shift_ari = in;                             // default no shift
            endcase
        end
    endfunction

    reg [63:0] next_q;

    always @(*) begin
        if (load)
            next_q = data;
        else if (ena)
            next_q = shift_ari(q, amount);
        else
            next_q = q;
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule