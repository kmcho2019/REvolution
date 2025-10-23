module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

    // Define the states
    reg [2:0] y;
    reg [2:0] next_y;

    // Determine next state and output based on current state and input
    always @(*) begin
        case (y)
            3'b000: begin
                if (!x) next_y = 3'b000;
                else next_y = 3'b001;
                z = 1'b0;
            end
            3'b001: begin
                if (!x) next_y = 3'b001;
                else next_y = 3'b100;
                z = 1'b0;
            end
            3'b010: begin
                if (!x) next_y = 3'b010;
                else next_y = 3'b001;
                z = 1'b0;
            end
            3'b011: begin
                if (!x) next_y = 3'b001;
                else next_y = 3'b010;
                z = 1'b1;
            end
            3'b100: begin
                if (!x) next_y = 3'b011;
                else next_y = 3'b100;
                z = 1'b1;
            end
            default: begin
                next_y = 3'b000;
                z = 1'b0;
            end
        endcase
    end

    // Update current state on positive edge of clock
    always @(posedge clk) begin
        if (reset) begin
            y <= 3'b000;
        end else begin
            y <= next_y;
        end
    end

endmodule