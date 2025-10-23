module TopModule (
    input          clk,
    input          load,
    input          ena,
    input  [1:0]   amount,
    input  [63:0]  data,
    output reg [63:0] q
);

    wire [63:0] shift_val;

    // Combinational shift logic
    assign shift_val = (amount == 2'b00) ? (q << 1) :
                       (amount == 2'b01) ? (q << 8) :
                       (amount == 2'b10) ? {q[63], q[63:1]} :      // arithmetic right shift by 1
                       /* amount == 2'b11 */ { {8{q[63]}}, q[63:8]}; // arithmetic right shift by 8

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift_val;
        end
        // else retain q
    end

endmodule