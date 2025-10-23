module CellModule(
    input left,
    input center,
    input right,
    output next_state
);

    // Implementation of Rule 110 using a case statement
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
            default: next_state = 1'bx;
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

    // Instantiate cell modules and connect them individually
    CellModule cell_modules[0:511] (
       .left  ({1'b0, current_state[511:1]}),
       .center(current_state),
       .right ({current_state[510:0], 1'b0}),
       .next_state(next_state)
    );

    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
        end else begin
            current_state <= next_state;
        end
    end

    assign q = current_state;

endmodule