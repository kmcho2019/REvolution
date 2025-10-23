module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state;  // OFF or ON

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        case (state)
            OFF: state <= j ? ON : OFF;
            ON:  state <= k ? OFF : ON;
        endcase
    end
end

assign out = state;

endmodule