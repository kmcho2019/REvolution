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

    // One-hot state encoding
    reg [3:0] state;
    reg fall_direction; // 0=left, 1=right
    
    // State definitions
    localparam WALK_L = 4'b0001;
    localparam WALK_R = 4'b0010;
    localparam FALL   = 4'b0100;
    
    // Next state logic (combinational)
    wire [3:0] next_state;
    wire next_fall_dir;
    
    assign next_state = 
        (areset) ? WALK_L :
        (state == WALK_L) ? 
            (!ground ? FALL : 
             bump_left ? WALK_R : WALK_L) :
        (state == WALK_R) ? 
            (!ground ? FALL : 
             bump_right ? WALK_L : WALK_R) :
        (state == FALL) ? 
            (ground ? (fall_direction ? WALK_R : WALK_L) : FALL) :
        WALK_L; // default
    
    assign next_fall_dir = 
        (state == WALK_L) ? 1'b0 :
        (state == WALK_R) ? 1'b1 :
        fall_direction; // maintain during fall
    
    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_direction <= 1'b0;
        end else begin
            state <= next_state;
            fall_direction <= next_fall_dir;
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALL);

endmodule