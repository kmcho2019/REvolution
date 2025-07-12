module JC_counter #(
    parameter WIDTH = 64
) (
    input clk,
    input rst_n,
    output reg [WIDTH-1:0] Q
);

wire [WIDTH-1:0] next_state_0 = {1'b0, Q[WIDTH-1:1]};
wire [WIDTH-1:0] next_state_1 = {1'b1, Q[WIDTH-1:1]};
wire terminal_state = (Q == {WIDTH{1'b0}}) || (Q == {WIDTH{1'b1}});

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= {WIDTH{1'b0}};
    end else if (!terminal_state) begin  // Clock gating hint
        Q <= Q[0] ? next_state_0 : next_state_1;
    end
    // Else maintain current state (implicit)
end

// synthesis attribute async_reg of Q is "true";
// synthesis attribute shreg_extract of Q is "no";

endmodule