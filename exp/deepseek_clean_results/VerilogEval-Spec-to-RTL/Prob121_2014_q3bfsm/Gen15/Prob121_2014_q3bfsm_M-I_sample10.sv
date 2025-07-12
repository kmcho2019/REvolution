module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // Gray-like state encoding to minimize transitions
    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            z <= 1'b0;
        end
        else begin
            case (state)
                3'b000: state <= x ? 3'b001 : 3'b000;
                3'b001: state <= x ? 3'b011 : 3'b001;  // Changed from 100 to 011 for Gray-like
                3'b010: state <= x ? 3'b001 : 3'b010;
                3'b011: begin
                    state <= x ? 3'b010 : 3'b001;
                    z <= 1'b1;
                end
                3'b100: begin
                    state <= x ? 3'b100 : 3'b011;
                    z <= 1'b1;
                end
                default: state <= 3'b000;
            endcase
            
            // Output register update
            if (!reset) begin
                z <= (state == 3'b011) || (state == 3'b100);
            end
        end
    end

endmodule