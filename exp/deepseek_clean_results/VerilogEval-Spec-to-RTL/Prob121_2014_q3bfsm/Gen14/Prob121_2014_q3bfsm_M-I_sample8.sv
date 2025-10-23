module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // Gray-coded states: 000, 001, 011, 010, 110
    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            z <= 1'b0;
        end
        else begin
            case (state)
                3'b000: state <= x ? 3'b001 : 3'b000;
                3'b001: state <= x ? 3'b110 : 3'b001;
                3'b011: state <= x ? 3'b001 : 3'b011;
                3'b010: state <= x ? 3'b011 : 3'b001;
                3'b110: state <= x ? 3'b110 : 3'b010;
            endcase
            
            // Output is registered to improve timing
            z <= (state == 3'b010) || (state == 3'b110);
        end
    end

endmodule