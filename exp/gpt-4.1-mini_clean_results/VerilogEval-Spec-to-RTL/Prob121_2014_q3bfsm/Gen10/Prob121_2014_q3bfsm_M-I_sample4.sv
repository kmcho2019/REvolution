module TopModule(
    input clk,
    input reset,
    input x,
    output z
);
    reg [2:0] y, y_next;

    // Next state logic (combinational)
    always @(*) begin
        case (y)
            3'b000: y_next = x ? 3'b001 : 3'b000;
            3'b001: y_next = x ? 3'b100 : 3'b001;
            3'b010: y_next = x ? 3'b001 : 3'b010;
            3'b011: y_next = x ? 3'b010 : 3'b001;
            3'b100: y_next = x ? 3'b100 : 3'b011;
            default: y_next = 3'b000;
        endcase
    end

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            y <= 3'b000;
        else
            y <= y_next;
    end

    // Optimized output logic using combinational expression
    assign z = (y[2] & ~y[1] & ~y[0]) | (~y[2] & y[1] & y[0]);

endmodule