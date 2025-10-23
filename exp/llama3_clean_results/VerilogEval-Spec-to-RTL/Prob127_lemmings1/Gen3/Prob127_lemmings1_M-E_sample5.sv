module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

// Internal state register
reg direction;

// Combinational logic to determine state transition
always @(*) begin
    if (bump_left && bump_right) begin
        direction <= ~direction;
    end else if (bump_left) begin
        direction <= 1'b1;
    end else if (bump_right) begin
        direction <= 1'b0;
    end 
end

// Sequential logic
always @ (posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0;
    end else begin
        // No need for additional logic, direction is updated in combinational block
    end
end

// Output logic
assign walk_left = ~direction;
assign walk_right = direction;

endmodule