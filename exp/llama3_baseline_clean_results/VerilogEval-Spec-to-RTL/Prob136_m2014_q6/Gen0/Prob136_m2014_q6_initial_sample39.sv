module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state;
reg [2:0] nextState;

always @(*) begin
    case (state)
        3'b000: begin // A
            if (~w) begin
                nextState = 3'b001; // B
            end else begin
                nextState = 3'b000; // A
            end
        end
        3'b001: begin // B
            if (~w) begin
                nextState = 3'b010; // C
            end else begin
                nextState = 3'b011; // D
            end
        end
        3'b010: begin // C
            if (~w) begin
                nextState = 3'b100; // E
            end else begin
                nextState = 3'b011; // D
            end
        end
        3'b011: begin // D
            if (~w) begin
                nextState = 3'b101; // F
            end else begin
                nextState = 3'b000; // A
            end
        end
        3'b100: begin // E
            if (w) begin
                nextState = 3'b100; // E
            end else begin
                nextState = 3'b011; // D
            end
        end
        3'b101: begin // F
            if (w) begin
                nextState = 3'b010; // C
            end else begin
                nextState = 3'b011; // D
            end
        end
        default: nextState = 3'b000; // default state A
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000; // reset to state A
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        3'b100: z = 1'b1; // E
        3'b101: z = 1'b1; // F
        default: z = 1'b0;
    endcase
end

endmodule