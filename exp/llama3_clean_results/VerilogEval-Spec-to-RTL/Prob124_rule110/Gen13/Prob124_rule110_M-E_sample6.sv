module CellModule(
    input left,
    input center,
    input right,
    output next_state
);

    // Simplified logic for Rule 110 using a Karnaugh map
    assign next_state = ~(left & center & right) & (left | center | right);

endmodule

module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    reg [511:0] current_state;

    // Instantiate cell modules and connect them in a linear array
    CellModule cell_modules[511:0] (
       .left  ({1'b0, current_state[511:1]}),
       .center(current_state),
       .right ({current_state[510:0], 1'b0}),
       .next_state(q)
    );

    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
        end else begin
            current_state <= q;
        end
    end

endmodule