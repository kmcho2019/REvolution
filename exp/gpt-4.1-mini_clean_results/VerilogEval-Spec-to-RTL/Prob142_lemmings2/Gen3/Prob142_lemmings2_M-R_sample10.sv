module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding
    typedef enum logic [1:0] {
        WL = 2'b00, // walking left
        WR = 2'b01, // walking right
        FL = 2'b10, // falling left
        FR = 2'b11  // falling right
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            WL: begin
                if (!ground) begin
                    next_state = FL; // start falling left
                end else if (bump_left && bump_right) begin
                    next_state = WR; // flip direction
                end else if (bump_left) begin
                    next_state = WR; // bump left => walk right
                end else if (bump_right) begin
                    next_state = WL; // bump right => walk left (no change actually)
                end else begin
                    next_state = WL; // stay walking left
                end
            end
            WR: begin
                if (!ground) begin
                    next_state = FR; // start falling right
                end else if (bump_left && bump_right) begin
                    next_state = WL; // flip direction
                end else if (bump_left) begin
                    next_state = WR; // bump left => walk right (no change)
                end else if (bump_right) begin
                    next_state = WL; // bump right => walk left
                end else begin
                    next_state = WR; // stay walking right
                end
            end
            FL: begin
                if (ground) begin
                    next_state = WL; // ground returns, resume walking left
                end else begin
                    next_state = FL; // keep falling left
                end
            end
            FR: begin
                if (ground) begin
                    next_state = WR; // ground returns, resume walking right
                end else begin
                    next_state = FR; // keep falling right
                end
            end
            default: next_state = WL; // default safe state
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL; // reset to walking left
        end else begin
            state <= next_state;
        end
    end

    // Output decoding
    assign walk_left  = (state == WL);
    assign walk_right = (state == WR);
    assign aaah       = (state == FL) || (state == FR);

endmodule