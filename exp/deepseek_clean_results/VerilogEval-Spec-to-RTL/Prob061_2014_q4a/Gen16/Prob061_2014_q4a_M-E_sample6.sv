module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// State encoding
localparam HOLD  = 2'b00;
localparam SHIFT = 2'b01;
localparam LOAD  = 2'b10;

reg [1:0] state;

always @(posedge clk) begin
    case (state)
        HOLD: begin
            if (L) state <= LOAD;
            else if (E) state <= SHIFT;
        end
        SHIFT: begin
            Q <= w;
            if (L) state <= LOAD;
            else if (E) state <= SHIFT;
            else state <= HOLD;
        end
        LOAD: begin
            Q <= R;
            if (E && !L) state <= SHIFT;
            else if (!L) state <= HOLD;
        end
        default: state <= HOLD;
    endcase
end

// Initialize state
initial begin
    state = HOLD;
    Q = 1'b0;
end

endmodule