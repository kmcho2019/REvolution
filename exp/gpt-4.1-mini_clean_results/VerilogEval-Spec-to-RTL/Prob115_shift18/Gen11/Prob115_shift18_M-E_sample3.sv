module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);
    reg [63:0] shift_by_1;
    reg [63:0] shift_by_8;
    reg [63:0] next_val;
    wire sign = q[63];

    always @* begin
        // Compute shift left and right by 1
        // Left shift 1: logical shift left by 1 bit
        shift_by_1 = (amount[1] == 1'b0) ? 
                      {q[62:0], 1'b0} :     // left shift by 1
                      {sign, q[63:1]};      // arithmetic right shift by 1

        // Compute shift left and right by 8
        // Left shift 8: logical shift left by 8 bits
        shift_by_8 = (amount[1] == 1'b0) ? 
                      {q[55:0], 8'b0} :     // left shift by 8
                      {{8{sign}}, q[63:8]}; // arithmetic right shift by 8

        // Select shift amount: amount[0] = 0 => shift by 1, = 1 => shift by 8
        if (load) begin
            next_val = data;
        end else if (ena) begin
            if (amount[0] == 1'b0)
                next_val = shift_by_1;
            else
                next_val = shift_by_8;
        end else begin
            next_val = q;
        end
    end

    always @(posedge clk) begin
        q <= next_val;
    end

endmodule