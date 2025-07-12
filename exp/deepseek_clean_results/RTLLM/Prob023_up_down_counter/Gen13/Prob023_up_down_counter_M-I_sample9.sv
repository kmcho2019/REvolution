module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Clock gating logic
wire count_enable = ~reset & (|count | up_down);
wire gated_clk = count_enable ? clk : 1'b0;

// Next count calculation using single 16-bit operation
wire [15:0] next_count = reset ? 16'h0000 : 
                        (up_down ? count + 1'b1 : count - 1'b1);

// Use a single always block with gated clock
always @(posedge gated_clk or posedge reset) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= next_count;
    end
end

endmodule