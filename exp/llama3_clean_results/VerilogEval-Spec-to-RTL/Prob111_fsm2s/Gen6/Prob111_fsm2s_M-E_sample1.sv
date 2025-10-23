module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // Using 2 bits to represent the states (OFF and ON)

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to OFF state
        out <= 1'b0;
    end else begin
        case ({state, j, k}) // Using a case statement to implement the state machine
            4'b0000, 4'b0001: begin state <= 2'b00; out <= 1'b0; end // OFF with j=0 and k=0 or k=1
            4'b0010: begin state <= 2'b01; out <= 1'b1; end // OFF with j=1
            4'b0100: begin state <= 2'b01; out <= 1'b1; end // ON with k=0
            4'b0101: begin state <= 2'b00; out <= 1'b0; end // ON with k=1
            default: begin state <= 2'b00; out <= 1'b0; end // Default state
        endcase
    end
end

endmodule