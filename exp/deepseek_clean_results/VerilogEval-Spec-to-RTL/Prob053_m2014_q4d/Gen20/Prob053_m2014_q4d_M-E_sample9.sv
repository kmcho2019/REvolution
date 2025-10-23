module TopModule (
    input clk,
    input in,
    output reg out
);

    // State transition logic
    wire next_state = in ^ out;

    // State update on clock edge
    always @(posedge clk) begin
        out <= next_state;
    end

endmodule