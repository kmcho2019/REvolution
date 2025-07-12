module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // One-hot encoding
reg [1:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01; // OFF state
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        2'b01: begin // OFF state
            if (j == 1'b1) begin
                next_state = 2'b10; // ON state
            end else begin
                next_state = 2'b01; // OFF state
            end
        end
        2'b10: begin // ON state
            if (k == 1'b1) begin
                next_state = 2'b01; // OFF state
            end else begin
                next_state = 2'b10; // ON state
            end
        end
        default: begin
            next_state = 2'b01; // OFF state (default)
        end
    endcase
end

assign out = (state == 2'b10)? 1'b1 : 1'b0; // Output based on current state

endmodule