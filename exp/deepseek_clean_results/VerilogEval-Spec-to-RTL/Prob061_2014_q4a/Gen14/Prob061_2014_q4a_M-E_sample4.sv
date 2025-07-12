module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// Define states
localparam SHIFT = 1'b0;
localparam LOAD  = 1'b1;

reg state;

always @(posedge clk) begin
    case (state)
        SHIFT: begin
            if (L) begin
                state <= LOAD;
                Q <= R;
            end
            else if (E) begin
                Q <= w;
            end
        end
        LOAD: begin
            if (E && !L) begin
                state <= SHIFT;
                Q <= w;
            end
            else if (L) begin
                Q <= R;
            end
        end
    endcase
end

// Initial state
initial begin
    state = SHIFT;
    Q = 1'b0;
end

endmodule