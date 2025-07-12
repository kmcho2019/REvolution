module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

always @(*) begin
    case (state)
        2'b00: {next_state, out} = in ? {2'b01, 1'b0} : {2'b00, 1'b0};
        2'b01: {next_state, out} = in ? {2'b01, 1'b0} : {2'b10, 1'b0};
        2'b10: {next_state, out} = in ? {2'b11, 1'b0} : {2'b00, 1'b0};
        2'b11: {next_state, out} = in ? {2'b01, 1'b1} : {2'b10, 1'b1};
    endcase
end

endmodule