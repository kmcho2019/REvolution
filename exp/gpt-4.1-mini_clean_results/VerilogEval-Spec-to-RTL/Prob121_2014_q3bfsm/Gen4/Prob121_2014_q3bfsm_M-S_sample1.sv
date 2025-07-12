module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else begin
            if (state == 3'b000)
                state <= x ? 3'b001 : 3'b000;
            else if (state == 3'b001)
                state <= x ? 3'b100 : 3'b001;
            else if (state == 3'b010)
                state <= x ? 3'b001 : 3'b010;
            else if (state == 3'b011)
                state <= x ? 3'b010 : 3'b001;
            else if (state == 3'b100)
                state <= x ? 3'b100 : 3'b011;
            else
                state <= 3'b000;
        end
    end

    always @(*) begin
        z = (state == 3'b011) || (state == 3'b100);
    end

endmodule