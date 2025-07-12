module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state;
    reg next_z;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            z <= 1'b0;
        end
        else begin
            state <= case (state)
                3'b000: x ? 3'b001 : 3'b000;
                3'b001: x ? 3'b100 : 3'b001;
                3'b010: x ? 3'b001 : 3'b010;
                3'b011: x ? 3'b010 : 3'b001;
                3'b100: x ? 3'b100 : 3'b011;
            endcase;
            z <= (state == 3'b011) || (state == 3'b100);
        end
    end

endmodule