module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // Current state

// Combinational logic for next state and output
always @(*) begin
    case (y)
        3'b000: begin
            if (!x) y = 3'b000;
            else    y = 3'b001;
            z = 1'b0;
        end
        3'b001: begin
            if (!x) y = 3'b001;
            else    y = 3'b100;
            z = 1'b0;
        end
        3'b010: begin
            if (!x) y = 3'b010;
            else    y = 3'b001;
            z = 1'b0;
        end
        3'b011: begin
            if (!x) y = 3'b001;
            else    y = 3'b010;
            z = 1'b1;
        end
        3'b100: begin
            if (!x) y = 3'b011;
            else    y = 3'b100;
            z = 1'b1;
        end
        default: begin
            y = 3'b000; // Default to state 000
            z = 1'b0;
        end
    endcase
end

// Sequential logic for state update on positive clock edge with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // Reset to state 000
    end else begin
        // No need to update y here as it's already updated in the combinational logic
    end
end

endmodule