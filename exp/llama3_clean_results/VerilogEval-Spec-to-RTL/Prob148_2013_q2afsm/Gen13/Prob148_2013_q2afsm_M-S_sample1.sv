module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state; // Reduced state width to 2 bits
reg [2:0] g; // Declare g as reg for internal use

// State flip-flops
always @(posedge clk) begin
    if (~resetn) state <= 2'b00;
    else begin
        case (state)
            2'b00: 
                if (r[0]) state <= 2'b01;
                else if (r[1]) state <= 2'b10;
                else if (r[2]) state <= 2'b00; // State D is not needed explicitly
                else state <= 2'b00;
            2'b01: if (!r[0]) state <= 2'b00; else state <= 2'b01;
            2'b10: if (!r[1]) state <= 2'b00; else state <= 2'b10;
            default: state <= 2'b00;
        endcase
    end
end

// Output logic
always @(*) begin
    g = 3'b000; // Default output
    case (state)
        2'b01: g[0] = 1'b1; // Set g[0] when in state B
        2'b10: g[1] = 1'b1; // Set g[1] when in state C
    endcase
end

endmodule