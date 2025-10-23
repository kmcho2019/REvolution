module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

wire [3:0] next_state;

// Combinational logic for next state
assign next_state = load ? data : 
                   ena ? {1'b0, q[3:1]} : 
                   q;

// Sequential logic with async reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end
    else begin
        q <= next_state;
    end
end

endmodule