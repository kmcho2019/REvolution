module Cell(
    input logic left,
    input logic center,
    input logic right,
    output logic next_state
);

always_comb begin
    case ({left, center, right})
        3'b111: next_state = 1'b0;
        3'b110: next_state = 1'b1;
        3'b101: next_state = 1'b1;
        3'b100: next_state = 1'b0;
        3'b011: next_state = 1'b1;
        3'b010: next_state = 1'b1;
        3'b001: next_state = 1'b1;
        3'b000: next_state = 1'b0;
        default: next_state = 1'b0;
    endcase
end

endmodule

module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

Cell cells[511:0] (
    .left({1'b0, current_state[511:1]}),
    .center(current_state),
    .right({current_state[510:0], 1'b0})
);

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            current_state[i] <= cells[i].next_state;
        end
    end
end

assign q = current_state;

endmodule