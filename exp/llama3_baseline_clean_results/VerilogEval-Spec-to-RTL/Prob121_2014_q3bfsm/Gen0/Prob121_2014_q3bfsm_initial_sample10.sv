module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

reg [2:0] y; // current state

// Combinational logic to determine next state
always @(*) begin
    case (y)
        3'b000: begin
            if (!x) begin
                y = 3'b000;
            end else begin
                y = 3'b001;
            end
        end
        3'b001: begin
            if (!x) begin
                y = 3'b001;
            end else begin
                y = 3'b100;
            end
        end
        3'b010: begin
            if (!x) begin
                y = 3'b010;
            end else begin
                y = 3'b001;
            end
        end
        3'b011: begin
            if (!x) begin
                y = 3'b001;
            end else begin
                y = 3'b010;
            end
        end
        3'b100: begin
            if (!x) begin
                y = 3'b011;
            end else begin
                y = 3'b100;
            end
        end
        default: begin
            y = 3'b000;
        end
    endcase
end

// Sequential logic to update current state and output
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else begin
        z <= (y == 3'b011 || y == 3'b100); // output z based on current state
    end
end

endmodule