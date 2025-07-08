module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    reg [2:0] state, next_state;

    // State transition combinational logic
    always @(*) begin
        case (state)
            3'b000: begin
                z = 0;
                next_state = x ? 3'b001 : 3'b000;
            end
            3'b001: begin
                z = 0;
                next_state = x ? 3'b100 : 3'b001;
            end
            3'b010: begin
                z = 0;
                next_state = x ? 3'b001 : 3'b010;
            end
            3'b011: begin
                z = 1;
                next_state = x ? 3'b010 : 3'b001;
            end
            3'b100: begin
                z = 1;
                next_state = x ? 3'b100 : 3'b011;
            end
            default: begin
                // Default to reset state for safety
                z = 0;
                next_state = 3'b000;
            end
        endcase
    end

    // Sequential logic: state update on posedge clk with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state;
    end

endmodule