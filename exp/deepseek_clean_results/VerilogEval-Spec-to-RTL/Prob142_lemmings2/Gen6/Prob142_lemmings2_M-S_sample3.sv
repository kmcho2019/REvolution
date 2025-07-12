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
    reg [1:0] state;  // [0]=dir (0=left,1=right), [1]=falling
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00;  // Left, not falling
        end
        else begin
            if (state[1]) begin  // If falling
                if (ground) state[1] <= 1'b0;  // Stop falling
            end
            else if (!ground) begin
                state[1] <= 1'b1;  // Start falling
            end
            else if ((state[0] ? bump_right : bump_left)) begin
                state[0] <= ~state[0];  // Toggle direction
            end
        end
    end
    
    assign walk_left = ~state[1] & ~state[0];
    assign walk_right = ~state[1] & state[0];
    assign aaah = state[1];
endmodule