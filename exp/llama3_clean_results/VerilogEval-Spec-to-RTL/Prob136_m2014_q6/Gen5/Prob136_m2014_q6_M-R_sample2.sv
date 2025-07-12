module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] currentState;

always @(posedge clk) begin
    if (reset) begin
        currentState <= 3'b000; // A
    end else begin
        case (currentState)
            3'b000: begin // A
                if (w) begin
                    currentState <= 3'b000; // A
                end else begin
                    currentState <= 3'b001; // B
                end
            end
            3'b001: begin // B
                if (w) begin
                    currentState <= 3'b011; // D
                end else begin
                    currentState <= 3'b010; // C
                end
            end
            3'b010: begin // C
                if (w) begin
                    currentState <= 3'b011; // D
                end else begin
                    currentState <= 3'b100; // E
                end
            end
            3'b011: begin // D
                if (w) begin
                    currentState <= 3'b000; // A
                end else begin
                    currentState <= 3'b101; // F
                end
            end
            3'b100: begin // E
                if (w) begin
                    currentState <= 3'b011; // D
                end else begin
                    currentState <= 3'b100; // E
                end
            end
            3'b101: begin // F
                if (w) begin
                    currentState <= 3'b011; // D
                end else begin
                    currentState <= 3'b010; // C
                end
            end
        endcase
    end
end

assign z = (currentState == 3'b100) || (currentState == 3'b101); // E or F

endmodule