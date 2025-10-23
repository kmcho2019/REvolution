module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state;
reg [1:0] prev_state;

// Sequential logic for FSM
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b11; // BELOW
        prev_state <= 3'b11; // BELOW
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_state <= state;
        if (~s[2] && ~s[1] && ~s[0]) begin
            state <= 3'b11; // BELOW
        end else if (~s[2] && ~s[1] && s[0]) begin
            state <= 3'b10; // BETWEEN_MIDDLE_LOW
        end else if (~s[2] && s[1] && s[0]) begin
            state <= 3'b01; // BETWEEN_HIGH_MIDDLE
        end else begin
            state <= 3'b00; // ABOVE
        end
    end
end

// Combinational logic for output
assign fr2 = (state == 3'b11);
assign fr1 = (state == 3'b11 || state == 3'b10);
assign fr0 = (state == 3'b11 || state == 3'b10 || state == 3'b01);
assign dfr = ((state == 3'b10 && prev_state == 3'b11) || (state == 3'b01 && prev_state == 3'b10) || (state == 3'b11 && prev_state == 3'b10));

endmodule