module TopModule (
    input         clk,
    input         load,
    input  [1:0]  ena,
    input  [99:0] data,
    output [99:0] q
);

    reg [99:0] reg_data;

    // Clock enable: update register only on load or rotate enable
    wire ce = load | (ena == 2'b01) | (ena == 2'b10);

    always @(posedge clk) begin
        if (ce) begin
            if (load) begin
                reg_data <= data;
            end else begin
                case (ena)
                    2'b01: reg_data <= {reg_data[0], reg_data[99:1]};       // rotate right by 1
                    2'b10: reg_data <= {reg_data[98:0], reg_data[99]};      // rotate left by 1
                    default: reg_data <= reg_data;                           // no change (should not happen as ce=0)
                endcase
            end
        end
    end

    assign q = reg_data;

endmodule