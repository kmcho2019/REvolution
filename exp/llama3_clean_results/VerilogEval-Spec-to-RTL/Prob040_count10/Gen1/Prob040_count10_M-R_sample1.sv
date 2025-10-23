module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

enum {S0, S1, S2, S3, S4, S5, S6, S7, S8, S9} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        S0: next_state = (count == 4'd9) ? S0 : S1;
        S1: next_state = (count == 4'd9) ? S0 : S2;
        S2: next_state = (count == 4'd9) ? S0 : S3;
        S3: next_state = (count == 4'd9) ? S0 : S4;
        S4: next_state = (count == 4'd9) ? S0 : S5;
        S5: next_state = (count == 4'd9) ? S0 : S6;
        S6: next_state = (count == 4'd9) ? S0 : S7;
        S7: next_state = (count == 4'd9) ? S0 : S8;
        S8: next_state = (count == 4'd9) ? S0 : S9;
        S9: next_state = S0;
        default: next_state = S0;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
    end else if (next_state == S0 && state != S0) begin
        count <= 4'd0;
    end else begin
        count <= count + 4'd1;
    end
end

assign q = count;

endmodule