module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] Y; // Current state

always @(posedge clk) begin
    Y <= y; // Update current state with next state at the positive edge of the clock
end

always @(*) begin
    case (Y)
        3'b000: begin
            if (!x) begin
                y <= 3'b000;
                z <= 1'b0;
            end else begin
                y <= 3'b001;
                z <= 1'b0;
            end
        end
        3'b001: begin
            if (!x) begin
                y <= 3'b001;
                z <= 1'b0;
            end else begin
                y <= 3'b100;
                z <= 1'b0;
            end
        end
        3'b010: begin
            if (!x) begin
                y <= 3'b010;
                z <= 1'b0;
            end else begin
                y <= 3'b001;
                z <= 1'b0;
            end
        end
        3'b011: begin
            if (!x) begin
                y <= 3'b001;
                z <= 1'b1;
            end else begin
                y <= 3'b010;
                z <= 1'b1;
            end
        end
        3'b100: begin
            if (!x) begin
                y <= 3'b011;
                z <= 1'b1;
            end else begin
                y <= 3'b100;
                z <= 1'b1;
            end
        end
        default: begin
            y <= 3'b000;
            z <= 1'b0;
        end
    endcase
    Y0 = y[0]; // Output Y0 is Y[0] of the next state
end

endmodule