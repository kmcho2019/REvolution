module TopModule (
    input        clk,
    input        a,
    output reg [2:0] q
);

// Define states explicitly for readability and maintainability
localparam [2:0]
    S0 = 3'd0,
    S1 = 3'd1,
    S2 = 3'd2,
    S3 = 3'd3,
    S4 = 3'd4,
    S5 = 3'd5,
    S6 = 3'd6;

reg [2:0] next_state;

always @(*) begin
    if (a) begin
        next_state = S4;
    end else begin
        case (q)
            S4: next_state = S5;
            S5: next_state = S6;
            S6: next_state = S0;
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S4;
            default: next_state = S4;
        endcase
    end
end

always @(posedge clk) begin
    q <= next_state;
end

endmodule