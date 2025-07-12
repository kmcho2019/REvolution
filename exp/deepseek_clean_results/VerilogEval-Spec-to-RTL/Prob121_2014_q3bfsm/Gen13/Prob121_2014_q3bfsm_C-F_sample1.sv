module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;
    wire clk_en;

    // Clock gating logic - enable only when state will change
    assign clk_en = reset || 
                   (state == 3'b000 && x) ||
                   (state == 3'b001 && x) ||
                   (state == 3'b010 && x) ||
                   (state == 3'b011) ||
                   (state == 3'b100 && !x);

    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else if (clk_en) begin
            case (state)
                3'b000: state <= x ? 3'b001 : 3'b000;
                3'b001: state <= x ? 3'b100 : 3'b001;
                3'b010: state <= x ? 3'b001 : 3'b010;
                3'b011: state <= x ? 3'b010 : 3'b001;
                3'b100: state <= x ? 3'b100 : 3'b011;
            endcase
        end
    end

    assign z = (state == 3'b011) || (state == 3'b100);

endmodule