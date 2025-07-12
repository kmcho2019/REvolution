module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

logic state;

assign out = state;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 0;
    end else begin
        case (state)
            0: state <= j;
            1: state <= ~k;
        endcase
    end
end

endmodule