// TopModule with state machine approach
module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);
    reg [1:0] state;
    reg temp_assign;
    reg temp_always_comb;
    reg temp_always_ff;

    always @(*) begin
        case (state)
            2'b00: temp_assign = a ^ b;
            2'b01: temp_always_comb = a ^ b;
            2'b10: temp_always_ff = a ^ b;
            default: temp_assign = 1'b0;
        endcase
    end

    always @(posedge clk) begin
        case (state)
            2'b00: out_assign <= temp_assign;
            2'b01: out_always_comb <= temp_always_comb;
            2'b10: out_always_ff <= temp_always_ff;
            default: out_assign <= 1'b0;
        endcase
    end

    always @(posedge clk) begin
        state <= state + 1;
        if (state == 2'b11) state <= 2'b00;
    end

    assign out_assign = temp_assign;
    assign out_always_comb = temp_always_comb;
endmodule