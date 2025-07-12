module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

reg [0:0] state; // Using binary encoding for states
reg [0:0] next_state;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 0; // OFF state
    end else begin
        state <= next_state;
    end
end

always @* begin
    case (state)
        0: begin // OFF state
            if (j) begin
                next_state = 1; // ON state
            end else begin
                next_state = 0; // OFF state
            end
            out = 0;
        end
        1: begin // ON state
            if (k) begin
                next_state = 0; // OFF state
            end else begin
                next_state = 1; // ON state
            end
            out = 1;
        end
        default: begin
            next_state = 0; // OFF state (default)
            out = 0;
        end
    endcase
end

endmodule