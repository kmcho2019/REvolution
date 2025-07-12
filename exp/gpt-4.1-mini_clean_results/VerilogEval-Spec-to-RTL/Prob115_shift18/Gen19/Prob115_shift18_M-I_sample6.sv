module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire sign = q[63];
    wire [63:0] shift_left1  = {q[62:0], 1'b0};
    wire [63:0] shift_left8  = {q[55:0], 8'b0};
    wire [63:0] shift_right1 = {sign, q[63:1]};
    wire [63:0] shift_right8 = {{8{sign}}, q[63:8]};

    reg [63:0] shift_result;

    always @(*) begin
        if (!ena) begin
            // If not enabled, hold current value
            shift_result = q;
        end else begin
            case (amount)
                2'b00: shift_result = shift_left1;
                2'b01: shift_result = shift_left8;
                2'b10: shift_result = shift_right1;
                2'b11: shift_result = shift_right8;
                default: shift_result = q;
            endcase
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= shift_result;
    end

endmodule