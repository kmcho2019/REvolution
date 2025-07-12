module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Combinational function to perform arithmetic shift based on current q and amount
    // Returns the next shifted value
    function [63:0] shifted_value;
        input [63:0] current;
        input [1:0]  amt;
        reg msb;
        begin
            msb = current[63];
            case (amt)
                2'b00: // shift left by 1
                    shifted_value = {current[62:0], 1'b0};
                2'b01: // shift left by 8
                    shifted_value = {current[55:0], 8'd0};
                2'b10: // arithmetic shift right by 1
                    shifted_value = {msb, current[63:1]};
                2'b11: // arithmetic shift right by 8
                    shifted_value = {{8{msb}}, current[63:8]};
                default:
                    shifted_value = current; // Should never occur
            endcase
        end
    endfunction

    wire [63:0] next_val = (load) ? data :
                           (ena)  ? shifted_value(q, amount) :
                                    q;

    always @(posedge clk) begin
        q <= next_val;
    end

endmodule