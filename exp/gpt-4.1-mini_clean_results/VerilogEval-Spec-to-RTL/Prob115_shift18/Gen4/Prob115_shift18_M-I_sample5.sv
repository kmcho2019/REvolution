module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Extract shift direction and amount
    wire dir_right = amount[1]; // 0: left shift, 1: arithmetic right shift
    wire [5:0] shift_amt = (amount[0]) ? 6'd8 : 6'd1;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            if (!dir_right) begin
                // Logical left shift by 1 or 8 bits, fill zeros
                // Using shift operators with constants, synth tools optimize this well
                q <= data; // will be replaced below by q before shift
                q <= (q << shift_amt);
            end else begin
                // Arithmetic right shift by 1 or 8 bits
                // >>> is arithmetic right shift in Verilog-2001
                q <= q >>> shift_amt;
            end
        end
        // else hold q
    end

endmodule