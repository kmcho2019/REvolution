module CellularAutomaton(
    input left,
    input center,
    input right,
    output next_state
);
    assign next_state = left ^ right;
endmodule

module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);
    reg [511:0] q_reg;
    wire [511:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 512; i++) begin
            wire left, center, right;
            assign left = (i == 0)? 1'b0 : q_reg[i - 1];
            assign center = q_reg[i];
            assign right = (i == 511)? 1'b0 : q_reg[i + 1];
            
            CellularAutomaton ca(
               .left(left),
               .center(center),
               .right(right),
               .next_state(next_state[i])
            );
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q_reg <= data;
        end else begin
            q_reg <= next_state;
        end
    end

    assign q = q_reg;
endmodule