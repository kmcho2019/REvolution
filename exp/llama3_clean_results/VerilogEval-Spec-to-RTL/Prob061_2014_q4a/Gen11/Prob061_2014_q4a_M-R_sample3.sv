module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    case ({L, E})
        2'b00: begin
            // Do nothing, Q remains the same
        end
        2'b01: begin
            Q <= w;
        end
        2'b10: begin
            Q <= R;
        end
        2'b11: begin
            // Since L has priority, load R
            Q <= R;
        end
    endcase
end

endmodule