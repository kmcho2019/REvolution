module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

logic state;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 0;
    end else begin
        case(state)
            0: state <= j ? 1 : 0;
            1: state <= ~k ? 1 : 0;
        endcase
    end
end

assign out = state;

endmodule