module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    reg [2:0] state;
    reg [2:0] next_state;

    // Next state and output logic in a combinational block using case statement
    always @(*) begin
        case (state)
            3'b000: begin
                next_state = x ? 3'b001 : 3'b000;
                z = 1'b0;
            end
            3'b001: begin
                next_state = x ? 3'b100 : 3'b001;
                z = 1'b0;
            end
            3'b010: begin
                next_state = x ? 3'b001 : 3'b010;
                z = 1'b0;
            end
            3'b011: begin
                next_state = x ? 3'b010 : 3'b001;
                z = 1'b1;
            end
            3'b100: begin
                next_state = x ? 3'b100 : 3'b011;
                z = 1'b1;
            end
            default: begin
                next_state = 3'b000;
                z = 1'b0;
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state;
    end

endmodule