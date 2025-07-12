module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    reg nextQ;

    // Encoded select signals: priority L > E > hold
    always @(*) begin
        case ({L, E})
            2'b10: nextQ = R;   // load has highest priority
            2'b01: nextQ = w;   // shift enabled
            default: nextQ = Q; // hold
        endcase
    end

    always @(posedge clk) begin
        Q <= nextQ;
    end

endmodule