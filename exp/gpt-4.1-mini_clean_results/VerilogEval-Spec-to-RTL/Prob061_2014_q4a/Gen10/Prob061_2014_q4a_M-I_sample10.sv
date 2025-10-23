module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    reg nextQ;
    reg [1:0] sel;

    always @* begin
        // Priority encoding: L has higher priority than E
        if (L)
            sel = 2'b01;
        else if (E)
            sel = 2'b10;
        else
            sel = 2'b00;
    end

    always @* begin
        case(sel)
            2'b00: nextQ = Q;  // Hold
            2'b01: nextQ = R;  // Load
            2'b10: nextQ = w;  // Shift in from previous stage
            default: nextQ = Q;
        endcase
    end

    always @(posedge clk) begin
        Q <= nextQ;
    end

endmodule