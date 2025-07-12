module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// State encoding
localparam S4 = 2'b00;
localparam S5 = 2'b01;
localparam S6 = 2'b10;
localparam S0 = 2'b11;

reg [1:0] state, next_state;

// State transitions
always @(*) begin
    if (a) begin
        next_state = S4;
    end else begin
        case (state)
            S4: next_state = S5;
            S5: next_state = S6;
            S6: next_state = S0;
            S0: next_state = S4;
            default: next_state = S4;
        endcase
    end
end

// State register
always @(posedge clk) begin
    state <= next_state;
end

// Output mapping
always @(*) begin
    case (state)
        S4: q = 3'd4;
        S5: q = 3'd5;
        S6: q = 3'd6;
        S0: q = 3'd0;
        default: q = 3'd4;
    endcase
end

endmodule