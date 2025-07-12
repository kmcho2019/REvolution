module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // state: 0 = copy bits, 1 = invert bits
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z <= 1'b0;
        end else begin
            if (state == 1'b0) begin
                // Copy input until first '1' bit
                z <= x;
                if (x == 1'b1)
                    state <= 1'b1;
            end else begin
                // Invert bits after first '1'
                z <= ~x;
                state <= 1'b1;
            end
        end
    end

endmodule