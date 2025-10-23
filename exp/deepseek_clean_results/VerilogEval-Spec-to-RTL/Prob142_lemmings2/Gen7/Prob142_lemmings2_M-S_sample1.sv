module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    reg [1:0] state; // [1]=falling, [0]=direction (0=left, 1=right)
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00; // walk left
        end
        else if (state[1]) begin
            state[1] <= ~ground; // stop falling when ground=1
        end
        else if (!ground) begin
            state <= 2'b10; // start falling, keep direction
        end
        else if ((state[0] & bump_right) | (~state[0] & bump_left)) begin
            state[0] <= ~state[0]; // toggle direction
        end
    end
    
    assign walk_left = ~state[1] & ~state[0];
    assign walk_right = ~state[1] & state[0];
    assign aaah = state[1];
endmodule