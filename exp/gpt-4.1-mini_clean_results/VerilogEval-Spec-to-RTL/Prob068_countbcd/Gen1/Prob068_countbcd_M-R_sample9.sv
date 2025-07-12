module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    wire [3:0] ones, tens, hundreds, thousands;

    assign ones      = q[3:0];
    assign tens      = q[7:4];
    assign hundreds  = q[11:8];
    assign thousands = q[15:12];

    // Combinational signals indicating when each digit should enable the next digit
    wire ena1 = (ones == 4'd9);
    wire ena2 = (tens == 4'd9) && ena1;
    wire ena3 = (hundreds == 4'd9) && ena2;

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'd0;
        end else begin
            // Increment ones digit every cycle
            if (ena1)
                q[3:0] <= 4'd0;
            else
                q[3:0] <= ones + 1'b1;

            // Increment tens digit if ones digit rolls over
            if (ena1) begin
                if (ena2)
                    q[7:4] <= 4'd0;
                else
                    q[7:4] <= tens + 1'b1;
            end

            // Increment hundreds digit if tens digit rolls over
            if (ena2) begin
                if (ena3)
                    q[11:8] <= 4'd0;
                else
                    q[11:8] <= hundreds + 1'b1;
            end

            // Increment thousands digit if hundreds digit rolls over
            if (ena3) begin
                if (thousands == 4'd9)
                    q[15:12] <= 4'd0;
                else
                    q[15:12] <= thousands + 1'b1;
            end

            ena <= {ena3, ena2, ena1};
        end
    end

endmodule