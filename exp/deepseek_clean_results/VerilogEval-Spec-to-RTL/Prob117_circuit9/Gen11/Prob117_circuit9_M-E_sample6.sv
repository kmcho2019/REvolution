module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// One-hot encoded states (though output is binary)
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;
localparam S6 = 3'b110;

always @(posedge clk) begin
    if (a) begin
        q <= S4;
    end else begin
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