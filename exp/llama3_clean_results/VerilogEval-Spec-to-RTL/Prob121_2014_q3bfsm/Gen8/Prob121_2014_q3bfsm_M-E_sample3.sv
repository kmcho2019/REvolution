// Hybrid Encoding Scheme FSM
module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

// Define the states
localparam [2:0] S000 = 3'b000;
localparam [2:0] S001 = 3'b001;
localparam [2:0] S010 = 3'b010;
localparam [2:0] S011 = 3'b011;
localparam [2:0] S100 = 3'b100;

// Current state register
reg [2:0] y;

// Next state and output logic using LUT
always @(*) begin
    case (y)
        S000: begin
            if (!x) y = S000;
            else y = S001;
            z = 1'b0;
        end
        S001: begin
            if (!x) y = S001;
            else y = S100;
            z = 1'b0;
        end
        S010: begin
            if (!x) y = S010;
            else y = S001;
            z = 1'b0;
        end
        S011: begin
            if (!x) y = S001;
            else y = S010;
            z = 1'b1;
        end
        S100: begin
            if (!x) y = S011;
            else y = S100;
            z = 1'b1;
        end
        default: begin
            y = S000;
            z = 1'b0;
        end
    endcase
end

// Dynamic clock gating
reg clk_enable;
always @(*) begin
    if (y == S000 && !x) clk_enable = 1'b0;
    else if (y == S001 && !x) clk_enable = 1'b0;
    else if (y == S010 && !x) clk_enable = 1'b0;
    else if (y == S011 && !x) clk_enable = 1'b0;
    else if (y == S100 && !x) clk_enable = 1'b0;
    else clk_enable = 1'b1;
end

// Clock enable for clock gating
always @(posedge clk) begin
    if (reset) begin
        y <= S000; // synchronous active high reset
    end else if (clk_enable) begin
        // Update state based on next state logic
        case (y)
            S000: begin
                if (!x) y <= S000;
                else y <= S001;
            end
            S001: begin
                if (!x) y <= S001;
                else y <= S100;
            end
            S010: begin
                if (!x) y <= S010;
                else y <= S001;
            end
            S011: begin
                if (!x) y <= S001;
                else y <= S010;
            end
            S100: begin
                if (!x) y <= S011;
                else y <= S100;
            end
            default: y <= S000;
        endcase
    end
end

endmodule