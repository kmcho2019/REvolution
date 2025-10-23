module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// One-hot encoded states (q values 0-6)
parameter [2:0] S0 = 3'b000;
parameter [2:0] S1 = 3'b001;
parameter [2:0] S2 = 3'b010;
parameter [2:0] S3 = 3'b011;
parameter [2:0] S4 = 3'b100;
parameter [2:0] S5 = 3'b101;
parameter [2:0] S6 = 3'b110;

always @(posedge clk) begin
    if (a) begin
        q <= S4;  // Constant output when a is high
    end
    else begin
        // State transitions (simple shift with wrap-around)
        case (q)
            S0: q <= S1;
            S1: q <= S2;
            S2: q <= S3;
            S3: q <= S4;
            S4: q <= S5;
            S5: q <= S6;
            S6: q <= S0;
            default: q <= S0;
        endcase
    end
end

endmodule