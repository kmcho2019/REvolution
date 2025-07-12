module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

reg [3:0] next_state;

// Combinational logic for next state
always @(*) begin
    if (load) begin
        next_state = data;
    end
    else if (ena) begin
        next_state = {1'b0, q[3:1]};
    end
    else begin
        next_state = q;
    end
end

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