module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // Using 2 bits to represent the 2 states (OFF, ON)

// Define state values
localparam OFF = 2'b00;
localparam ON  = 2'b01;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= OFF;
        out <= 1'b0;
    end else begin
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON;
                    out <= 1'b1;
                end else begin
                    state <= OFF;
                    out <= 1'b0;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                    out <= 1'b0;
                end else begin
                    state <= ON;
                    out <= 1'b1;
                end
            end
            default: begin
                state <= OFF;
                out <= 1'b0;
            end
        endcase
    end
end

endmodule