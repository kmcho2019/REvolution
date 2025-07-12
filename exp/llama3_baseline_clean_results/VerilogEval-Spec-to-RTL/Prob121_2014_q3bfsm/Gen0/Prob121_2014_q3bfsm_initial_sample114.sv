module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // Current state

always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        y <= 3'b000;
    end else begin
        case (y)
            3'b000: begin
                if (!x)
                    y <= 3'b000;
                else
                    y <= 3'b001;
            end
            3'b001: begin
                if (!x)
                    y <= 3'b001;
                else
                    y <= 3'b100;
            end
            3'b010: begin
                if (!x)
                    y <= 3'b010;
                else
                    y <= 3'b001;
            end
            3'b011: begin
                if (!x)
                    y <= 3'b001;
                else
                    y <= 3'b010;
            end
            3'b100: begin
                if (!x)
                    y <= 3'b011;
                else
                    y <= 3'b100;
            end
            default: y <= 3'b000; // Default to initial state
        endcase
    end

    // Determine output z based on the current state and input x
    case (y)
        3'b000, 3'b001, 3'b010: z <= 1'b0;
        3'b011, 3'b100: z <= 1'b1;
        default: z <= 1'b0; // Default output
    endcase
end

endmodule