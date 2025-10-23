module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding: A=00, B=01, C=10, D=11
    reg [1:0] state;

    // Output logic
    assign g = (state == 2'b01) ? 3'b001 :  // State B: g0=1
               (state == 2'b10) ? 3'b010 :  // State C: g1=1
               (state == 2'b11) ? 3'b100 :  // State D: g2=1
               3'b000;                      // State A: no grants

    // State transitions
    always @(posedge clk) begin
        if (!resetn) begin
            state <= 2'b00;  // Reset to state A
        end else begin
            case (state)
                2'b00: begin  // State A
                    if (r[0]) state <= 2'b01;      // Highest priority
                    else if (r[1]) state <= 2'b10; // Medium priority
                    else if (r[2]) state <= 2'b11; // Lowest priority
                end
                2'b01: state <= r[0] ? 2'b01 : 2'b00;  // State B
                2'b10: state <= r[1] ? 2'b10 : 2'b00;  // State C
                2'b11: state <= r[2] ? 2'b11 : 2'b00;  // State D
            endcase
        end
    end

endmodule