module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg [1:0] state;

always @(posedge clk) begin
    case (state)
        2'b00: begin // Hold state
            if (L) state <= 2'b10;
            else if (E) state <= 2'b01;
        end
        2'b01: begin // Shift state
            Q <= w;
            state <= (L) ? 2'b10 : (E) ? 2'b01 : 2'b00;
        end
        2'b10: begin // Load state
            Q <= R;
            state <= (E) ? 2'b01 : 2'b00;
        end
        default: state <= 2'b00;
    endcase
end

initial begin
    state = 2'b00;
    Q = 1'b0;
end

endmodule