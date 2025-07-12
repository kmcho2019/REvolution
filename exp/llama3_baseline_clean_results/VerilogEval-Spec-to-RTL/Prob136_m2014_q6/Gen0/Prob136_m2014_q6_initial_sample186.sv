module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

always @(*) begin
    case (current_state)
        3'b000: begin // A
            if (w) begin
                next_state = 3'b000; // A
            end else begin
                next_state = 3'b001; // B
            end
        end
        3'b001: begin // B
            if (w) begin
                next_state = 3'b011; // D
            end else begin
                next_state = 3'b010; // C
            end
        end
        3'b010: begin // C
            if (w) begin
                next_state = 3'b011; // D
            end else begin
                next_state = 3'b100; // E
            end
        end
        3'b011: begin // D
            if (w) begin
                next_state = 3'b000; // A
            end else begin
                next_state = 3'b110; // F
            end
        end
        3'b100: begin // E
            if (w) begin
                next_state = 3'b011; // D
            end else begin
                next_state = 3'b100; // E
            end
        end
        3'b101: begin // F
            if (w) begin
                next_state = 3'b011; // D
            end else begin
                next_state = 3'b010; // C
            end
        end
        default: begin
            next_state = 3'b000; // A
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 3'b000; // A
        z <= 0;
    end else begin
        current_state <= next_state;
        z <= current_state[2]; // MSB of current state
    end
end

endmodule