module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // State variable

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // Reset state to 000
    end else begin
        case (y)
            3'b000: begin
                if (~x) begin
                    y <= 3'b000;
                end else begin
                    y <= 3'b001;
                end
            end
            3'b001: begin
                if (~x) begin
                    y <= 3'b001;
                end else begin
                    y <= 3'b100;
                end
            end
            3'b010: begin
                if (~x) begin
                    y <= 3'b010;
                end else begin
                    y <= 3'b001;
                end
            end
            3'b011: begin
                if (~x) begin
                    y <= 3'b001;
                end else begin
                    y <= 3'b010;
                end
            end
            3'b100: begin
                if (~x) begin
                    y <= 3'b011;
                end else begin
                    y <= 3'b100;
                end
            end
            default: begin
                y <= 3'b000; // Handle undefined states
            end
        endcase
    end
end

always @(*) begin
    case (y)
        3'b000: z = 1'b0;
        3'b001: z = 1'b0;
        3'b010: z = 1'b0;
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0; // Handle undefined states
    endcase
end

endmodule