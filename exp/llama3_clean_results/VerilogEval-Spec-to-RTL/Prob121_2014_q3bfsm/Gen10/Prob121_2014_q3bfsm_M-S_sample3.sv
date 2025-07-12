module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
        z <= 1'b0;
    end else begin
        case (y)
            3'b000: if (!x) y <= 3'b000; else y <= 3'b001;
            3'b001: if (!x) y <= 3'b001; else y <= 3'b100;
            3'b010: if (!x) y <= 3'b010; else y <= 3'b001;
            3'b011: if (!x) y <= 3'b001; else y <= 3'b010;
            3'b100: if (!x) y <= 3'b011; else y <= 3'b100;
            default: y <= 3'b000;
        endcase

        // Output generation
        case (y)
            3'b011, 3'b100: z <= 1'b1;
            default: z <= 1'b0;
        endcase
    end
end

endmodule