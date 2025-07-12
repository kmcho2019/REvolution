module TopModule(
    input   clk,
    input   reset,
    input   w,
    output  z
);

reg [2:0] state;
reg [2:0] next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        3'b000: // A
            if (w) begin
                next_state = 3'b000; // A
                z = 1'b0;
            end else begin
                next_state = 3'b001; // B
                z = 1'b0;
            end
        3'b001: // B
            if (w) begin
                next_state = 3'b011; // D
                z = 1'b0;
            end else begin
                next_state = 3'b010; // C
                z = 1'b0;
            end
        3'b010: // C
            if (w) begin
                next_state = 3'b011; // D
                z = 1'b0;
            end else begin
                next_state = 3'b100; // E
                z = 1'b0;
            end
        3'b011: // D
            if (w) begin
                next_state = 3'b000; // A
                z = 1'b0;
            end else begin
                next_state = 3'b101; // F
                z = 1'b0;
            end
        3'b100: // E
            if (w) begin
                next_state = 3'b011; // D
                z = 1'b1;
            end else begin
                next_state = 3'b100; // E
                z = 1'b1;
            end
        3'b101: // F
            if (w) begin
                next_state = 3'b011; // D
                z = 1'b1;
            end else begin
                next_state = 3'b010; // C
                z = 1'b1;
            end
        default: begin
            next_state = 3'b000; // A
            z = 1'b0;
        end
    endcase
end

endmodule