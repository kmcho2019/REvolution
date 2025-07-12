module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
        end else begin
            case (state)
                3'b000: state <= x ? 3'b001 : 3'b000;
                3'b001: state <= x ? 3'b100 : 3'b001;
                3'b010: state <= x ? 3'b001 : 3'b010;
                3'b011: state <= x ? 3'b010 : 3'b001;
                3'b100: state <= x ? 3'b100 : 3'b011;
                default: state <= 3'b000;
            endcase
        end
    end

    assign z = (state == 3'b011) || (state == 3'b100);

endmodule