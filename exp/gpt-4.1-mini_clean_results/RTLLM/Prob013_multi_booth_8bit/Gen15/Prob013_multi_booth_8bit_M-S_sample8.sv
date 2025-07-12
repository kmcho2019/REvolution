module multi_booth_8bit (
    input            clk,
    input            reset,
    input      [7:0] a,      // multiplicand
    input      [7:0] b,      // multiplier
    output reg [15:0] p,     // product
    output reg       rdy      // ready signal
);

    reg [4:0] count;
    reg [31:0] reg_ab;       // {partial product[15:0], multiplier[15:0]}

    wire [15:0] multiplicand = {{8{a[7]}}, a}; // sign-extended multiplicand

    always @(posedge clk) begin
        if (reset) begin
            // Initialize combined register: upper 16 bits zero, lower 16 bits = sign-extended multiplier (b)
            reg_ab <= {16'd0, {{8{b[7]}}, b}};
            count <= 5'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (!rdy) begin
            if (count < 5'd16) begin
                // Check LSB of multiplier part (reg_ab[0])
                if (reg_ab[0] == 1'b1)
                    reg_ab[31:16] <= reg_ab[31:16] + multiplicand;
                // Arithmetic right shift reg_ab by 1 bit
                reg_ab <= {reg_ab[31], reg_ab[31:1]};
                count <= count + 1;
            end else begin
                rdy <= 1'b1;
                p <= reg_ab[31:16];
            end
        end
    end

endmodule