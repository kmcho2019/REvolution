module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    // Combinational logic to perform shift based on current q and amount
    function [63:0] shifted_val;
        input [63:0] curr_val;
        input [1:0] shift_amt;
        reg msb;
        begin
            msb = curr_val[63];
            case (shift_amt)
                2'b00: shifted_val = {curr_val[62:0], 1'b0};       // left shift by 1
                2'b01: shifted_val = {curr_val[55:0], 8'b0};       // left shift by 8
                2'b10: shifted_val = {msb, curr_val[63:1]};        // arithmetic right shift by 1
                2'b11: shifted_val = {{8{msb}}, curr_val[63:8]};   // arithmetic right shift by 8
                default: shifted_val = curr_val;                    // no shift (should not happen)
            endcase
        end
    endfunction

    wire [63:0] next_val;

    assign next_val = (load) ? data :
                      (ena)  ? shifted_val(q, amount) :
                               q;

    always @(posedge clk) begin
        q <= next_val;
    end

endmodule