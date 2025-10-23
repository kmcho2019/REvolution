module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state;
    wire clk_en;

    // Clock gating when state remains unchanged
    assign clk_en = reset || 
                   (state == 3'b000 && ~x) ||
                   (state == 3'b001 && ~x) ||
                   (state == 3'b010 && ~x) ||
                   (state == 3'b100 && x);

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            z <= 1'b0;
        end
        else if (clk_en) begin
            case (state) // synthesis parallel_case
                3'b000: state <= x ? 3'b001 : 3'b000;
                3'b001: state <= x ? 3'b100 : 3'b001;
                3'b010: state <= x ? 3'b001 : 3'b010;
                3'b011: state <= x ? 3'b010 : 3'b001;
                3'b100: state <= x ? 3'b100 : 3'b011;
            endcase
            
            // Registered output
            z <= (state == 3'b011) || (state == 3'b100);
        end
    end

endmodule