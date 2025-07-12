module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_q;
wire update_en = shift_ena | count_ena;

// Optimized next-state logic
assign next_q = shift_ena ? {q[2:0], data} : 
                (q - 1'b1); // count_ena implied by update_en

// Power-optimized sequential element
always @(posedge clk) begin
    if (update_en) begin
        q <= next_q;
    end
end

endmodule